# SR-IOV 运行时解析 —— 对照真实案例逐节走读

> 案例来源：Shaowen Chen《SR-IOV Technology》(2024-11-03)
> <https://www.chenshaowen.com/en/blog/sr-iov-technique.html>
>
> 作者环境：腾讯云 TKE 节点（`bj6-a-kas-t41-01`），Intel X710 系列万兆网卡
> （PF 驱动 `i40e`，PF ID `8086:37d1`，BDF `0000:3d:00.0`），`bond1` = eth4+eth5
> （10G×2 聚合），集群 CNI 是 Calico；机器上还有一块带 SR-IOV 能力的 NVIDIA GPU。
>
> 配套篇目：[sriov.md](./sriov.md)（概念）、[sriov-runtime.md](./sriov-runtime.md)（VM 直通主线）。
> 本篇是**容器/K8s 主线**——和 VM 场景的关键差异见 §0。

---

## 0. 先建立心智地图：本文场景 vs VM 直通场景

同一个 `echo N > sriov_numvfs`，之后走两条完全不同的路：

```text
                    echo 2 > /sys/class/net/eth0/device/sriov_numvfs
                    （硬件长出 VF: 3d:02.0 / 3d:02.1，两条路完全相同）
                                    │
              ┌─────────────────────┴─────────────────────┐
              ▼ VM 主线（sriov-runtime.md）                ▼ K8s 主线（本篇/文章）
     VF 绑 vfio-pci（host 上无 netdev）           VF 被内核自动绑上 iavf 驱动
     QEMU 把整块 VF 硬件直通给独立内核            → host 上出现 VF netdev
     guest 里自己跑 ixgbevf/iavf                 → sriov-cni 把这个 netdev "搬进"
                                                    Pod 的 network namespace
```

为什么容器走不了 VM 那条路？**容器没有自己的内核**，没法像 VM 一样把 PCI
设备直通给"另一个内核"去枚举。所以容器场景的玩法是：VF 仍然由 host 内核
的 `iavf` 驱动管着，只是把驱动产生的 **netdev 移动进 Pod 的 netns**——
数据面照样直通硬件（收发不经过 host 协议栈和 CNI 软件转发），但控制面
（驱动、中断、PCI 管理）全在 host。

这就是文章 §4.8 里 Pod 中出现 `net1` 网卡的本质：**一块真 VF 的 netdev，
被从 host netns 挪了进来**。

---

## 1. 文章 §2：打开软硬件支持

### 做了什么

1. BIOS 里开三项：**VT-d**（定向 I/O 虚拟化）、**SR-IOV**、**IOMMU**。
2. 改 grub：

```bash
vim /etc/default/grub          # GRUB_CMDLINE_LINUX 加 "intel_iommu=on iommu=pt"
grub-mkconfig -o /boot/grub/grub.cfg
reboot
dmesg | grep -e DMAR -e IOMMU   # 验证
```

### 运行时逻辑

- BIOS 开 SR-IOV 的一个隐藏作用：**给 VF 预留 MMIO/BAR 地址空间**。VF 的
  BAR 是开机时固件在 PCIe 地址空间里划出来的，BIOS 不开，后面 `echo N` 时
  内核可能因资源不足失败（dmesg 报 `can't allocate BAR`）。
- BIOS 同时生成/暴露 **DMAR ACPI 表**，内核启动时据此初始化 VT-d 硬件。
- `iommu=pt`：host 自用设备不做 DMA 翻译（零开销），只有直通设备才建页表。

### 系统里的变化（文件级清单）

| 对象 | 变化 | 怎么看 |
|---|---|---|
| `/etc/default/grub` | 被编辑（唯一持久改动） | `grep CMDLINE /etc/default/grub` |
| `/boot/grub/grub.cfg` | 重新生成 | — |
| `/proc/cmdline` | 重启后含 `intel_iommu=on iommu=pt` | `cat /proc/cmdline` |
| `/sys/kernel/iommu_groups/` | 整棵树出现，设备按 ACS 分组 | `ls /sys/kernel/iommu_groups \| wc -l` |
| `/dev/vfio/vfio` | vfio 容器节点出现 (char 10,196) | `ls /dev/vfio/` |
| 内核日志 | DMAR/IOMMU 初始化行 | `dmesg \| grep -e DMAR -e IOMMU` |

> 勘误/提示：`grub-mkconfig -o /boot/grub/grub.cfg` 是 Arch/手工风格。
> Ubuntu 直接 `update-grub`；RHEL/CentOS 是
> `grub2-mkconfig -o /boot/grub2/grub.cfg`（UEFI 则是
> `/boot/efi/EFI/redhat/grub.cfg`）。

---

## 2. 文章 §3：检查本地网络设备

### 3.0 `lspci -v | grep -i SR-IOV` —— 谁有资格玩

文章输出：

```text
Capabilities: [bcc] Single Root I/O Virtualization (SR-IOV)   ← NVIDIA GPU
Capabilities: [160] Single Root I/O Virtualization (SR-IOV)   ← Intel 网卡 ×4
```

**运行时逻辑**：`[160]`/`[bcc]` 是 SR-IOV **扩展能力结构在 PCI 配置空间里
的偏移地址**（扩展配置空间 0x100 以上，经 ECAM 访问）。lspci 只是把每个
设备的配置空间读出来解析，**纯只读操作，系统无任何变化**。

想看得更深一层（这决定了后面 VF 的 BDF 长什么样）：

```bash
$ lspci -vvv -s 3d:00.0 | grep -A 6 'Single Root'
        Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
                IOVCap: Migration- 10BitTagReq- Interrupt Message Number: 000
                IOVCtl: Enable- Migration- Interrupt- MSE+ ARIHierarchy+
                IOVSta: RoE- UnsupReq- DevPwr-
                Initial VFs: 64, Total VFs: 64, Number of VFs: 0
                VF offset: 16, stride: 1        ← 关键!
                VF Device ID: 37cd              ← VF 的设备 ID（不是 PF 的 37d1）
```

- `Total VFs: 64` = `sriov_totalvfs` 的来源
- `VF offset: 16, stride: 1`：VF 的 RID = PF 的 RID + 16 + n。
  PF 是 `3d:00.0`，所以 VF 从 `3d:02.0` 开始（device 号 00+2），依次
  `3d:02.1 ... 3d:02.7, 3d:03.0 ...`——这解释了文章里
  `lspci | grep Virtual` 看到的 `3d:02.0`、`3d:02.1`。
- `VF Device ID: 37cd`：**VF 的 PCI ID 和 PF 不同**（"Ethernet Virtual
  Function 700 Series"）。后面 §4.5 的坑就和这个有关。
- 那行 `[bcc]` NVIDIA GPU：Ampere 及以后的数据中心卡才有 SR-IOV 能力
  （vGPU 新框架的硬件底座）；消费级 GeForce（如 RTX 5070）没有，
  WSL2 里走的是另一条 GPU-PV 路（`/dev/dxg`）。

### 3.1 认识现有的网卡

文章输出：

```bash
$ ls /sys/class/net/
eth0  eth1  bond1  lo  calixxx ...
```

| 接口 | 本质 | 背后是什么 |
|---|---|---|
| `eth0`/`eth1`/`eth4`/`eth5` | 物理网卡 netdev | symlink → `/sys/devices/pci.../0000:3d:00.0/net/eth0`，有 `device/` 指向 PCI 设备 |
| `bond1` | bonding 虚拟接口 | **纯软件对象，没有 PCI device**（`/sys/class/net/bond1/device` 不存在！） |
| `lo` | 回环 | 纯软件 |
| `calixxx` | Calico 的 veth host 端 | 每个 Pod 一条，另一端在 Pod netns 里叫 eth0 |

bond 的从属关系（procfs 由 bonding 驱动**即时生成**，不是磁盘文件）：

```bash
$ cat /proc/net/bonding/bond1
Ethernet Channel Bonding Driver: v3.7.1 ...
Slave Interface: eth5   Speed: 10000 Mbps
Slave Interface: eth4   Speed: 10000 Mbps     # 2×10G 聚合成 20G
```

**为什么文章强调"SR-IOV 只对物理 ethX 做，不能对 bond 做"**——现在可以说
到文件层面了：`sriov_numvfs` 位于 `/sys/class/net/<if>/device/` 下，而
`device` 是指向 PCI 设备的 symlink；bond1 没有 PCI 设备，这个路径根本不存在：

```bash
$ ls /sys/class/net/bond1/device
ls: cannot access '...': No such file or directory
$ ls /sys/class/net/eth0/device/sriov_numvfs      # 物理口才有
```

（bond 的 slave eth4/eth5 各自是物理口，理论上可以分别开 VF，但 VF 流量
会绕过 bond 的链路聚合/故障切换逻辑，一般不这么混用。作者的做法是：
host 管理流量走 bond1，`eth0` 这个独立物理口专供 VF/Pod 使用——业务网和
管理网在物理上分离。）

### 3.2 创建 VF —— `echo 2 > sriov_numvfs`

```bash
$ cat /sys/class/net/eth0/device/sriov_numvfs    # 之前
0
$ echo 2 > /sys/class/net/eth0/device/sriov_numvfs
$ lspci | grep Virtual                            # 之后
3d:02.0 Ethernet controller: Intel Corporation Ethernet Virtual Function 700 Series (rev 09)
3d:02.1 Ethernet controller: Intel Corporation Ethernet Virtual Function 700 Series (rev 09)
```

**内核调用链（i40e 版）**：

```text
sysfs 写 "2"
 → drivers/pci/iov.c: sriov_numvfs_store()
 → pci_sriov_configure()
 → i40e_sriov_configure()                 ← PF 驱动的回调
    ├─ pci_enable_sriov(pdev, 2)
    │   └─ 写 3d:00.0 配置空间 offset 0x160 的 SR-IOV cap:
    │        NumVFs=2, VF Enable=1         ← 硬件从这一刻起在总线上应答两个新 RID
    │   └─ 内核按 offset=16/stride=1 算出 3d:02.0、3d:02.1，逐个枚举:
    │        读配置空间(device id=37cd) → 分配 VF BAR → 建 sysfs 节点
    │        → 划入独立 IOMMU group → 发 udev add 事件
    └─ i40e 硬件侧: 给每个 VF 分配 VSI(虚拟交换实例)、队列对、
       生成随机 MAC 并写入硬件转发表
```

**系统里新增/变化的每一个对象**（都可在 shell 验证）：

```bash
# (1) PCI 设备树: 两个新目录
ls /sys/bus/pci/devices/ | grep '3d:02'      # 0000:3d:02.0  0000:3d:02.1

# (2) PF ↔ VF 的 symlink 互指
ls -l /sys/bus/pci/devices/0000:3d:00.0/virtfn*   # virtfn0 -> ../0000:3d:02.0
readlink /sys/bus/pci/devices/0000:3d:02.0/physfn # ../0000:3d:00.0

# (3) IOMMU group 数量 +2
ls /sys/kernel/iommu_groups/*/devices/ | grep '3d:02'

# (4) udev 事件流（另开终端 udevadm monitor --udev 再 echo 可看到）
#     add /devices/pci.../0000:3d:00.0/0000:3d:02.0 (pci)  ×2

# (5) dmesg
#     pci 0000:3d:02.0: [8086:37cd] type 00 class 0x020000
#     i40e 0000:3d:00.0: SR-IOV enabled with 2 VFs

# (6) K8s/netdevice 场景特有：VF 会被自动绑上 iavf 驱动！
#     37cd 在 iavf 的 PCI ID 表里 → 内核自动 probe → host 上出现 VF netdev
lsmod | grep iavf
ls /sys/class/net/                            # 多出 VF 的 netdev（如 enp61s0f0v0）
#     （VM 直通场景则相反：故意不绑任何驱动，留给 vfio-pci）
```

**文章里 `ip link show eth0` 输出的逐字段解释**：

```text
4: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN ...
    link/ether 90:f7:b2:4b:dc:3d ...            ← PF 自己的 MAC
    vf 0     link/ether 2e:3a:41:bc:02:cc ..., spoof checking on, link-state auto, trust off
    vf 1     link/ether 5a:d4:e4:45:83:7b ..., spoof checking on, link-state auto, trust off
    altname enp61s0f0                            ← 可预测命名: 0x3d=61 → bus61 slot0 func0
```

- `vf 0/vf 1` 两行是**创建 VF 后才出现**的——`ip link` 通过 netlink 向
  i40e 驱动查询 VF 状态，行内容就是驱动内存里的 VF 表，**不产生新文件**。
- `link/ether 2e:3a:...`：i40e 建 VF 时自动生成的随机 MAC（管理面写入硬件）。
- `spoof checking on`：i40e 默认开启——VF 发出的包源 MAC/VLAN 必须与管理面
  设置一致，否则在网卡 eSwitch 直接丢弃（多租户隔离基础）。
- `trust off`：VF 无权开混杂/多播/promisc。
- `link-state auto`：VF 的载波状态跟随 PF；`state DOWN` + `qdisc noop`
  说明 PF 本身没启用（没插线/没 up）——**这为 §4.8 里 Pod 的 net1 显示
  NO-CARRIER 埋下了伏笔**。

### 3.3 删除 VF —— `echo 0 > sriov_numvfs`

§3.2 的完全逆过程：iavf 先解绑（VF netdev 从 host 消失）→
`pci_disable_sriov` 写 VF Enable=0 → sysfs 目录、virtfn symlink、
IOMMU group、lspci 行、udev remove 事件全部回收。

> 注意：如果有 Pod 正在用 VF（netdev 在 Pod netns 里），必须先删 Pod
> 再 echo 0，否则会 busy/失败。

---

## 3. 文章 §4：K8s 里使用 —— 每个组件装上后系统多了什么、运行时干什么

全景（组件 → 安装落点 → 运行时职责）：

```text
┌─ multus (DaemonSet)          → /opt/cni/bin/multus*, /etc/cni/net.d/00-multus.conf
│    运行时: 接管 kubelet 的 CNI 调用, 按 Pod annotation 编排"多网卡"
├─ sriov-cni (DaemonSet)       → /opt/cni/bin/sriov
│    运行时: 把 VF 的 netdev 搬进 Pod netns, 改名 net1, 调 IPAM
├─ sriov-network-device-plugin → /var/lib/kubelet/device-plugins/*.sock (gRPC)
│    运行时: 扫描 VF → 注册成扩展资源 intel.com/eth0 → 参与调度/分配
├─ ConfigMap sriovdp-config    → etcd; 告诉 device plugin "哪些 VF 算这个资源池"
└─ NetworkAttachmentDefinition → etcd; 把"网络定义(type=sriov+ipam)"和"资源池"关联
```

### 4.2 multus：装完后节点文件系统的变化

```bash
# 新增的可执行文件（由 initContainer 从镜像里拷出）
ls /opt/cni/bin/ | grep multus        # multus-shim, multus-daemon ...

# CNI 配置被"劫持": multus 把自己写成 00 开头（kubelet 按字母序取第一个）
cat /etc/cni/net.d/00-multus.conf     # 顶层 CNI = multus, delegate = calico
ls /etc/cni/net.d/multus.d/           # multus.kubeconfig（multus 访问 API 的凭据）
```

**运行时逻辑**：Pod 创建 → kubelet 调 CNI ADD → 进的不再是 calico 而是
multus → multus 看 Pod 的 `k8s.v1.cni.cncf.io/networks` annotation →
先调 delegate（calico，得到 eth0）→ 再按 annotation 逐个调附加 CNI
（sriov，得到 net1）。

**文章那句卸载警告的原理**：卸载 multus 后若 `/etc/cni/net.d/00-multus.conf`
残留，kubelet 仍会按字母序选中它，却找不到 `/opt/cni/bin/multus` 二进制
→ 该节点所有新 Pod 卡 `ContainerCreating`（`failed to find plugin "multus"`）。

### 4.3 sriov-cni：只装一个二进制

```bash
ls -l /opt/cni/bin/sriov
```

运行时被 multus 以 stdin JSON 调用（关键字段 `deviceID: 0000:3d:02.0`），
动作：找到该 VF 的 iavf netdev → `ip link set <vf-netdev> netns <pod-netns>`
→ 改名 `net1` → 调 IPAM 配 IP。留下的痕迹：

```bash
# host-local IPAM 的分配记录（每个已分配 IP 一个文件）
ls /var/lib/cni/networks/sriov-network/
```

### 4.4 device plugin：让 VF 变成"可调度资源"

**注册**：启动后经 gRPC 连 kubelet 的 device manager：

```bash
ls /var/lib/kubelet/device-plugins/     # 多出它的 .sock; kubelet_internal_checkpoint
```

**发现**：读 ConfigMap `sriovdp-config` 的 selectors → 遍历
`/sys/bus/pci/devices/` 下所有带 `physfn` 的设备（= VF）→ 匹配的进资源池。

**暴露**：kubelet 把它上报进 Node 状态——这就是文章里 allocatable 多出的：

```json
"intel.com/eth0": "2"        ← 恰好等于 echo 2 创建的 VF 数
```

（这个 "2" 不是文件，是 Node API 对象里的状态；`echo 0` 删 VF 后会归零。
资源名 `intel.com/eth0` = resourcePrefix `intel.com` + resourceName `eth0`。）

### 4.5 配置 selectors —— ⚠️ 这里有个值得注意的细节

文章的做法：查 PF 的信息，然后填进 ConfigMap：

```bash
$ ethtool -i eth0
driver: i40e
bus-info: 0000:3d:00.0
$ lspci -s 0000:3d:00.0 -n
3d:00.0 0200: 8086:37d1 (rev 09)      # vendor 8086, device 37d1 ← 这是 PF 的 ID
```

```json
{ "resourceName": "eth0",
  "selectors": { "drivers": ["i40e"], "vendor": ["8086"], "device": ["37d1"] } }
```

**注意**：device plugin 的 selectors 匹配的严格来说是 **VF** 的属性——
而 VF 的 device ID 是 `37cd`（§3.0 里 `VF Device ID: 37cd` 可见）、驱动是
`iavf`，都不是 `37d1`/`i40e`。按官方文档语义，更稳妥的写法是用 PF 做锚点：

```json
{ "resourceName": "eth0",
  "selectors": { "vendor": ["8086"], "device": ["37cd"],
                 "pfNames": ["eth0"] } }
# 或 "rootDevices": ["0000:3d:00.0"]
```

文章实测跑通且 allocatable=2（可能是插件版本对 PF 属性做了兼容处理，或
博文做了简化）。自己复现时若发现 `intel.com/eth0` 是 0，第一个就查这里：
**selector 要填 VF 的 vendor/device/driver，用 pfNames/rootDevices 锚定 PF**。

### 4.6 NetworkAttachmentDefinition：把"网络"和"资源池"挂钩

```yaml
metadata:
  name: sriov-eth0
  annotations:
    k8s.v1.cni.cncf.io/resourceName: intel.com/eth0   # ← 挂钩资源池
spec:
  config: |
    { "type": "sriov", "ipam": { "type": "host-local" } }
```

存进 etcd 的一个 CRD 对象。运行时 multus 靠 `resourceName` annotation
知道"这个网络要用 intel.com/eth0 池子里的设备"，进而通过 kubelet 的
**PodResources API** 查到本 Pod 分到的具体 VF PCI 地址（见 4.8 时序）。
文章提示的"Pod 卡 ContainerCreating 多半是 NAD 配错"——因为 annotation
名字对不上时 multus 找不到 resourceName，CNI ADD 直接报错。

### 4.7 普通 Pod（对照组）

```text
1: lo
3: eth0@if1659: mtu 1450 ...    ← calico veth
```

- `eth0@if1659`：veth pair 的 Pod 端，`@if1659` 是 host netns 里对端
  `calixxx` 的接口索引；host 侧同时多一条 `caliXXX` 接口和路由。
- `mtu 1450`：1500 − IPIP 隧道开销，软件 overlay 的标志。

### 4.8 SR-IOV Pod —— 完整运行时时序（本篇重点）

Pod 定义的两个关键处：

```yaml
annotations:
  k8s.v1.cni.cncf.io/networks: sriov-eth0    # 要一块附加网卡
resources:
  requests: { intel.com/eth0: '1' }          # 申请一个 VF 资源
  limits:   { intel.com/eth0: '1' }
```

从 `kubectl apply` 到 `net1` 出现，系统里依次发生：

```text
1. scheduler: 过滤出 intel.com/eth0 allocatable≥1 的节点
2. kubelet 准入 Pod → gRPC 调 device plugin 的 Allocate()
     → 返回分到的 VF（PCI 地址 0000:3d:02.x）
     → 分配记录写入 /var/lib/kubelet/device-plugins/kubelet_internal_checkpoint
       （可直接 cat 这个 JSON, 能看到 pod→deviceIDs 映射）
3. kubelet 建 Pod sandbox(netns) → 调 CNI ADD → 进入 multus
4. multus 读 annotation → 取 NAD sriov-eth0 → 见 resourceName
     → 通过 kubelet PodResources API (/var/lib/kubelet/pod-resources/kubelet.sock)
       查"这个 Pod 分到的 VF PCI 地址"
5. multus 先调 calico delegate  → Pod 得到 eth0（集群网, 走 overlay, 供 DNS/kube-proxy）
6. multus 再调 sriov-cni, 传 deviceID=0000:3d:02.x
     → sriov-cni 找到 VF 的 iavf netdev（此刻还在 host netns）
     → 移入 Pod netns, 改名 net1, host-local IPAM 配 IP
     → host 上该 VF netdev 消失; /var/lib/cni/networks/ 下多一条分配记录
7. 容器起: ip link 看到 lo + eth0(calico) + net1(SR-IOV VF)
```

**文章 Pod 内输出逐字段解释**：

```text
7: net1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN ...
    link/ether 90:f7:b2:4b:dc:40 ...  alias eth0  altname enp61s0f0
```

- `NO-CARRIER` / `state DOWN`：**VF 的载波跟随 PF**（link-state auto），
  而 host 的 eth0 本身是 DOWN（§3.2 已见）——文章自己也点明了这一点。
  要真通流量：`ip link set eth0 up` 且物理口插线。
- `qdisc mq`：mq = multiqueue，**真实硬件网卡的特征**（veth 是 noqueue），
  一眼区分 net1 和 eth0 的出身。
- `mtu 1500`：没有 overlay 开销，和 eth0 的 1450 形成对比。
- `altname enp61s0f0`：VF 在 host 上按 PCI 位置生成的可预测名残留
  （bus 61 = 0x3d），暴露了它的 VF 身份。
- MAC `90:f7:b2:4b:dc:40` 与 PF（`...:3d`）连号，但 §3.2 时 `ip link` 显示
  的 vf 0 MAC 是 `2e:3a:...`——**VF 的 MAC 在生命周期里可能被多个环节改写**
  （PF 管理面设置 / iavf 驱动自行生成 / CNI 配置），两次输出时点不同。
  要一锤定音就显式固定：`ip link set eth0 vf 0 mac 52:54:00:xx:xx:xx`。

**数据面**（Pod 里进程发包的路径）：

```text
进程 → net1(iavf) → 描述符+doorbell(MMIO 直达硬件) → 网卡 DMA(IOMMU 翻译)
→ 物理口发出。不经过: host 协议栈、calico、iptables、任何 host 用户态进程
```

**Pod 删除时**：CNI DEL → sriov-cni 把 VF netdev 移回 host netns →
device plugin 释放资源 → allocatable 的 `intel.com/eth0` 恢复计数。

### 4.9 把 SR-IOV 设为默认网卡

annotation 换成 `v1.multus-cni.io/default-network: sriov-eth0` → Pod 的
**eth0 直接就是 VF**，不再经过 calico。

两点提醒：
- 文章文字说"要在 kube-system 下建 NAD"，贴的 YAML 却是 Pod——默认网络
  引用别的 namespace 的 NAD 要写全名（如 `kube-system/sriov-eth0`）。
- 换掉默认网络意味着绕开集群 CNI：kube-proxy/DNS/Service 流量都受影响，
  生产上通常保持"eth0=集群网 + net1=SR-IOV 数据面"的双网卡形态（即 4.8）。

### §5 文章提到的两个延伸

- **sriov-network-operator**（k8snetworkplumbingwg）：用 CRD
  （`SriovNetworkNodePolicy` / `SriovNetwork`）声明式管理——operator 自动
  替你做 `echo N > sriov_numvfs`、装 device plugin、写配置，且**持久化**
  （重启不丢，解决 §3.2 说的易失问题）。
- **k8s-rdma-shared-dev-plugin**：IB/RDMA 场景把 VF 以 rdma 资源暴露
  （`rdma/hca` 之类），配 RDMA CNI 给 Pod——作者生产环境（IB 网卡）用法。

---

## 4. 全文汇总表：文章每一步 → 系统变化 → 观察命令

| 文章步骤 | 动作 | 系统里新增/变化 | 验证命令 |
|---|---|---|---|
| §2 | BIOS 开 VT-d/SR-IOV/IOMMU | 固件暴露 DMAR 表; VF BAR 资源被预留 | — |
| §2 | 改 grub + 重启 | `/etc/default/grub`、`grub.cfg`、`/proc/cmdline`、`/sys/kernel/iommu_groups/*`、`/dev/vfio/vfio` | `dmesg \| grep DMAR` |
| §3.0 | lspci 查 SR-IOV | 无变化（只读配置空间） | `lspci -vvv -s 3d:00.0` |
| §3.1 | 看网卡/bond | 无变化（procfs 即时生成） | `cat /proc/net/bonding/bond1` |
| §3.2 | `echo 2 > sriov_numvfs` | 2 个 `/sys/bus/pci/devices/0000:3d:02.*`; PF 的 `virtfn0/1`; 2 个 IOMMU group; 2 行 lspci; udev add; dmesg; （K8s 场景）iavf 自动绑定 + VF netdev; `ip link` 多 vf 行 | `lspci \| grep Virtual` |
| §3.3 | `echo 0 > sriov_numvfs` | 上一行全部逆向消失 | 同上 |
| §4.2 | 装 multus | `/opt/cni/bin/multus*`、`/etc/cni/net.d/00-multus.conf`、`multus.d/multus.kubeconfig` | `cat 00-multus.conf` |
| §4.3 | 装 sriov-cni | `/opt/cni/bin/sriov` | `ls /opt/cni/bin/` |
| §4.4 | 装 device plugin | `/var/lib/kubelet/device-plugins/` 下 .sock; Node allocatable 多 `intel.com/eth0: 2` | `kubectl get node -o json` |
| §4.5 | 配 ConfigMap | etcd 里的 cm 对象; 资源池按 selectors 刷新 | `kubectl -n kube-system get cm sriovdp-config -o yaml` |
| §4.6 | 建 NAD | etcd 里的 CRD 对象 | `kubectl get net-attach-def` |
| §4.7 | 普通 Pod | host 多 `caliXXX` veth+路由; Pod netns 有 lo+eth0(1450) | `kubectl exec ... ip link` |
| §4.8 | SR-IOV Pod | checkpoint 写入分配; VF netdev 从 host 移入 Pod netns(net1, mq, 1500); `/var/lib/cni/networks/` 多 IP 记录 | `kubectl exec ... ip link`; `cat kubelet_internal_checkpoint` |
| §4.9 | 默认网卡 Pod | eth0 即 VF, 无 calico 接口 | 同上 |

---

## 5. 对照文章核出的注意点（复现前必读）

1. **§4.5 selector 的 ID 问题**：`37d1`/`i40e` 是 PF 的属性，VF 是
   `37cd`/`iavf`；device plugin 文档语义按 VF 匹配。稳妥写法：
   `vendor+device(VF 的)+pfNames` 或 `rootDevices`。资源池为 0 时先查这里。
2. **§2 grub 命令因发行版而异**（update-grub / grub2-mkconfig）。
3. **§4.9 正文与 YAML 不一致**（说建 NAD，贴的是 Pod）；跨 namespace 引用
   要写 `ns/name`。
4. **VF 的 MAC 不稳定**：创建时随机生成、驱动/CNI 可能改写；多租户环境
   务必用 `ip link set ... vf N mac` 显式固定 + spoofchk on。
5. **net1 NO-CARRIER 不是故障**：PF 没 up / 没插线而已，VF 载波跟随 PF。
6. **VF 状态全部易失**：重启后 numvfs=0；生产用 sriov-network-operator
   做持久化，或自写 systemd unit。
