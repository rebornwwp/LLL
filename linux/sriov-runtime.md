# SR-IOV 运行时逐步解析：每一步内核做了什么、shell 里能看到什么

> 配套阅读：[sriov.md](./sriov.md)（概念篇）。本篇讲"动手运行时"的完整时序。
>
> 示例平台：Intel 82599 双口万兆网卡（PF 驱动 `ixgbe`，VF 驱动 `ixgbevf`），
> PF 位于 `04:00.0`。所有输出为典型真实输出，BDF/数字随机器而异。

---

## 全流程时间线（先看全景）

```text
[1] 开机: intel_iommu=on
      └→ /sys/kernel/iommu_groups/* 出现, /dev/vfio/vfio 出现
[2] PF 驱动 probe (ixgbe)
      └→ /sys/class/net/eth0 出现, lspci -k 显示驱动
[3] echo 8 > sriov_numvfs            ← 魔法发生的一步
      └→ 硬件 SR-IOV 寄存器写入 → 总线上"长出"8 个新 PCI 设备
      └→ /sys/bus/pci/devices/04:10.0 ... 出现
      └→ PF 下出现 virtfn0..7, 每个 VF 下出现 physfn
      └→ 每个 VF 分到独立 IOMMU group, udev 收到 add 事件
[4] ip link set eth0 vf 0 mac/vlan/spoofchk
      └→ 不产生新文件, 纯 netlink → PF 驱动 → 硬件转发表
[5] VF 绑定 vfio-pci
      └→ /dev/vfio/<group号> 字符设备出现
[6] QEMU 启动, -device vfio-pci,host=04:10.0
      └→ guest 内存被 pin 住并映射进 IOMMU 页表
      └→ VF BAR mmap 进 guest 物理地址空间
      └→ MSI-X 接到 KVM irqfd/posted-interrupt
[7] Guest 内: 枚举到 VF → 绑 ixgbevf → 出现 netdev
      └→ 数据面: doorbell MMIO + DMA + 中断注入, 全程绕过 host
[8] VM 关机 → 映射解除; echo 0 > sriov_numvfs → 一切节点消失
```

---

## Step 0. 环境探测：这台机器到底能不能玩 SR-IOV

动手前先探测，三个命令定生死：

```bash
# (a) 有没有支持 SR-IOV 的 PCI 设备？（有 sriov_totalvfs 文件 = 硬件支持）
for d in /sys/bus/pci/devices/*; do
  [ -f "$d/sriov_totalvfs" ] && echo "$d total=$(cat $d/sriov_totalvfs)"
done

# (b) IOMMU 开了没有？（有编号目录 = 开了）
ls /sys/kernel/iommu_groups/ | wc -l

# (c) vfio 框架在不在？
ls /dev/vfio/
```

**本机（WSL2）真实探测结果**：

```text
(a) 无输出            → /sys/bus/pci/devices 下只有 4 个虚拟设备，无一支持 SR-IOV
(b) 0                 → IOMMU groups 为空
(c) vfio              → 只有 vfio 容器节点 (char 10,196)，无 group 节点
lspci: virtio-console / virtio-fs / 两个 Microsoft 3D controller [1414:008e]
```

> 顺带一提：WSL2 的那两个 "Microsoft 3D controller" 是 **GPU-PV**
> （GPU Paravirtualization），微软自研的 GPU 共享方案，思路和 SR-IOV
> 类似（硬件辅助切分 GPU），但不是 SR-IOV 标准。
>
> 结论：以下所有步骤在本机无法实跑，输出为典型 Intel 物理机示例。

---

## Step 1. 开机：IOMMU 初始化

### 触发

内核启动参数（写在 `/etc/default/grub`，`update-grub` 后重启生效）：

```text
GRUB_CMDLINE_LINUX="intel_iommu=on iommu=pt"
```

- `intel_iommu=on`：启用 VT-d（AMD 平台默认就开，无需参数）
- `iommu=pt`：host 自用设备走 passthrough 模式（不翻译，零开销），
  只有分给 VM 的设备才建 IOMMU 页表。**性能关键项**。

### 内核逻辑

1. 读 ACPI **DMAR 表**（AMD 是 IVRS 表），得知 IOMMU 硬件（VT-d 单元）在哪些位置、管哪些总线范围。
2. 初始化每个 IOMMU 硬件单元。
3. 枚举 PCI 设备时，按 **ACS 能力**把设备划分进一个个 **IOMMU group**——group 是直通的最小单位（同 group 的设备只能整组给同一个 VM）。
4. vfio 模块创建容器节点。

### 系统里多了什么 / 怎么看

```bash
$ cat /proc/cmdline | grep -o 'intel_iommu=on'
intel_iommu=on

$ dmesg | grep -e DMAR -e IOMMU | head
[    0.023451] DMAR: IOMMU enabled
[    0.023452] DMAR: Host address width 46
[    1.234567] iommu: Default domain type: Passthrough

$ ls /sys/kernel/iommu_groups/ | wc -l        # 每台机器几十个不等
42

# 每个 group 里有哪些设备（symlink 指向 PCI 设备）
$ find /sys/kernel/iommu_groups/ -type l | sort -V | head -5
/sys/kernel/iommu_groups/0/devices/0000:00:00.0
/sys/kernel/iommu_groups/1/devices/0000:00:01.0
/sys/kernel/iommu_groups/10/devices/0000:04:00.0   ← 我们的 PF
...

$ ls -l /dev/vfio/
crw------- 1 root root 10, 196 ... vfio        # 容器节点（misc 设备）
```

**关键变化**：`/sys/kernel/iommu_groups/` 整棵树出现；`/dev/vfio/vfio` 出现。

---

## Step 2. PF 驱动加载，网卡出现

### 触发

开机自动（udev 按 PCI ID 匹配 modalias 加载），或手动：

```bash
modprobe ixgbe
```

### 内核逻辑

1. `ixgbe_probe()` 被调用：映射 BAR、申请 MSI-X、初始化硬件。
2. 注册 netdev（`eth0`），注册一整套 `net_device_ops`——其中包含
   **`ndo_set_vf_mac` / `ndo_set_vf_vlan` / `ndo_set_vf_spoofchk` 等回调**，
   这就是后面 `ip link set ... vf` 命令的落点。
3. PCI core 在枚举该设备时就已发现其 SR-IOV Extended Capability，
   所以设备目录下有 `sriov_*` 系列文件（**文件在枚举时创建，但写入
   `sriov_numvfs` 需要驱动提供 `sriov_configure` 回调**，没驱动会报
   `write error: No such device`）。

### 系统里多了什么 / 怎么看

```bash
$ lspci -ks 04:00.0
04:00.0 Ethernet controller: Intel Corporation 82599ES 10-Gigabit SFI/Dual-Port Network Connection
        Subsystem: Intel Corporation Ethernet Server Adapter X520-2
        Kernel driver in use: ixgbe          ← 驱动已绑定
        Kernel modules: ixgbe

# 驱动 symlink（驱动绑定前不存在）
$ readlink /sys/bus/pci/devices/0000:04:00.0/driver
../../../../bus/pci/drivers/ixgbe

# 网卡 netdev 出现
$ ip link show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 ...
    link/ether 90:e2:ba:xx:xx:xx brd ff:ff:ff:ff:ff:ff

$ ls /sys/class/net/eth0/device/ | grep sriov
sriov_numvfs        # 当前 VF 数，现在是 0
sriov_totalvfs      # 硬件上限，82599 = 63
cat /sys/class/net/eth0/device/sriov_totalvfs
63
```

**关键变化**：`driver` symlink、`/sys/class/net/eth0` 及其整棵子树、
`ethtool -i eth0` 能报出 driver: ixgbe。

---

## Step 3. 创建 VF —— 最核心的一步

### 触发

```bash
echo 8 > /sys/class/net/eth0/device/sriov_numvfs
```

### 内核逻辑（调用链）

```text
sysfs write
 → drivers/pci/iov.c: sriov_numvfs_store()
 → pci_sriov_configure()
 → ixgbe 驱动的 .sriov_configure 回调
 → pci_enable_sriov(pdev, 8)
    ├─ 写 PF 配置空间的 SR-IOV Extended Capability:
    │    NumVFs = 8, VF Enable = 1        ← 硬件从此在总线上"长出"8个功能
    ├─ 按 First VF Offset / VF Stride 计算每个 VF 的 BDF
    │    (82599: offset=0x80 → VF 从 04:10.0 开始, 依次 .1 .2 ...)
    └─ 内核逐个 pci_scan 新 function:
         读配置空间 → 分配 SR-IOV BAR → 建 struct pci_dev
         → 建 sysfs 节点 → 按 ACS 划入 IOMMU group → 发 udev add 事件
 → ixgbe 驱动侧: 给每个 VF 分配队列/资源, 配置内部 eSwitch(VEB)
```

### 系统里多了什么（逐项列举）

```bash
# (1) lspci 多出 8 行 "Virtual Function"
$ lspci | grep -i virtual
04:10.0 Ethernet controller: Intel Corporation 82599 Ethernet Controller Virtual Function
04:10.1 Ethernet controller: Intel Corporation 82599 Ethernet Controller Virtual Function
04:10.2 Ethernet controller: Intel Corporation 82599 Ethernet Controller Virtual Function
...（共 8 行）

# (2) /sys/bus/pci/devices/ 下多出 8 个目录
$ ls /sys/bus/pci/devices/ | grep 04:10
0000:04:10.0
0000:04:10.1
...

# (3) VF 目录里有 physfn 指回 PF；PF 目录里出现 virtfn0..7
$ readlink /sys/bus/pci/devices/0000:04:10.0/physfn
../0000:04:00.0
$ ls -l /sys/bus/pci/devices/0000:04:00.0/ | grep virtfn
virtfn0 -> ../0000:04:10.0
virtfn1 -> ../0000:04:10.1
...
virtfn7 -> ../0000:04:10.7

# (4) 每个 VF 一个独立 IOMMU group（前提: 上游端口 ACS 正常）
$ ls /sys/kernel/iommu_groups/ | wc -l      # 42 → 50
$ find /sys/kernel/iommu_groups/ -name '0000:04:10.*' | head -2
/sys/kernel/iommu_groups/43/devices/0000:04:10.0
/sys/kernel/iommu_groups/44/devices/0000:04:10.1

# (5) 此时 VF 没有任何驱动绑定（host 故意不绑）
$ lspci -ks 04:10.0
04:10.0 Ethernet controller: Intel Corporation 82599 Ethernet Controller Virtual Function
        Kernel driver in use: <空>          ← 等着给 VM

# (6) host 上不会多出 VF 的 netdev！
$ ls /sys/class/net/
eth0  lo              # 依然只有 PF。VF 的 netdev 属于"谁绑驱动谁拥有"
# 注: 这是 VM 直通场景(host 故意不绑 VF 驱动)。K8s 容器场景相反——
# host 装有 iavf 时 VF 会被自动绑定并出现 VF netdev, 之后被 sriov-cni
# 搬进 Pod netns, 详见 sriov-example.md §0。
```

### 旁路观察手段

**另开一个终端跑 `udevadm monitor --udev`，再执行 echo**，能看到事件流：

```text
UDEV  [12345.678] add      /devices/pci0000:00/0000:00:03.0/0000:04:00.0/0000:04:10.0 (pci)
UDEV  [12345.679] add      /devices/pci0000:00/0000:00:03.0/0000:04:00.0/0000:04:10.1 (pci)
...（每个 VF 一条 add 事件）
```

**dmesg 也会留下痕迹**：

```bash
$ dmesg | tail -12
pci 0000:04:10.0: [8086:10ed] type 00 class 0x020000
pci 0000:04:10.0: reg 0x10: [mem 0xfb800000-0xfb81ffff 64bit]
pci 0000:04:10.0: Adding to iommu group 43
...（每个 VF 几行）
ixgbe 0000:04:00.0: SR-IOV enabled with 8 VFs
```

**销毁（echo 0）时以上全部逆向消失**：目录删、symlink 删、group 清空、
udev 发 remove 事件、lspci 行数还原。

> 注意：`sriov_numvfs` 是**易失的**——重启后归 0。持久化要靠
> systemd unit / dracut hook / K8s 的 sriov-network-operator。

---

## Step 4. 控制面配置：MAC / VLAN / spoofchk

### 触发

```bash
ip link set eth0 vf 0 mac 52:54:00:12:34:56
ip link set eth0 vf 0 vlan 100
ip link set eth0 vf 0 spoofchk on
ip link set eth0 vf 0 trust off
ip link set eth0 vf 0 max_tx_rate 1000     # 限速 1Gbps（可选）
```

### 内核逻辑

```text
iproute2 → netlink 消息 RTM_SETLINK (带 IFLA_VFINFO_LIST 属性)
 → ixgbe_ndo_set_vf_mac()   → 写硬件 MAC 过滤表 (RAH/RAL 寄存器)
 → ixgbe_ndo_set_vf_vlan()  → 写 VFTA VLAN 过滤表
 → spoofchk                 → eSwitch 规则: VF 发出的包源 MAC/VLAN 必须匹配, 否则丢弃
 → trust                    → off 时 VF 无权开混杂模式/多播
```

### 系统里多了什么 / 怎么看

**没有新文件产生**——这一步改的是硬件转发表和驱动内存状态。可见变化只有：

```bash
$ ip link show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 ...
    link/ether 90:e2:ba:xx:xx:xx brd ff:ff:ff:ff:ff:ff
    vf 0     link/ether 52:54:00:12:34:56 brd ff:ff:ff:ff:ff:ff, link-state auto, trust off, spoof checking on, vlan 100
    vf 1     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff, link-state auto
    ...
```

> 安全含义：之后 guest 里无论怎么改 MAC，spoofchk 会让不匹配的包在
> 网卡 eSwitch 就被丢掉——这就是多租户隔离的基础。

---

## Step 5. 把 VF 交给 vfio-pci

### 触发

```bash
modprobe vfio-pci
echo "vfio-pci" > /sys/bus/pci/devices/0000:04:10.0/driver_override
echo 0000:04:10.0 > /sys/bus/pci/drivers_probe
```

（VF 本来就没绑驱动，所以无需先 unbind；如果绑了 ixgbevf 要先
`echo 0000:04:10.0 > /sys/bus/pci/drivers/ixgbevf/unbind`。）

### 内核逻辑

1. `driver_override` 指定该设备只匹配 vfio-pci 驱动。
2. `drivers_probe` 触发重新匹配 → `vfio_pci_probe()`。
3. vfio 把设备注册进它所在的 IOMMU group → **以 group 号命名创建字符设备** `/dev/vfio/43`。

### 系统里多了什么 / 怎么看

```bash
# (1) /dev/vfio/ 下多出以 IOMMU group 号命名的字符设备
$ ls -l /dev/vfio/
crw------- 1 root root  10, 196 ... vfio
crw------- 1 root root 243,   0 ... 43        ← 新出现（主设备号动态分配）

# (2) VF 的驱动 symlink 指向 vfio-pci
$ readlink /sys/bus/pci/devices/0000:04:10.0/driver
../../../../bus/pci/drivers/vfio-pci
$ lspci -ks 04:10.0 | grep 'in use'
        Kernel driver in use: vfio-pci
```

---

## Step 6. QEMU 启动 VM

### 触发

```bash
qemu-system-x86_64 -enable-kvm -m 8G \
  -device vfio-pci,host=0000:04:10.0 \
  ...
```

（libvirt 则是在 domain XML 里写 `<hostdev>`，`virsh start` 后效果相同。）

### 内部逻辑（QEMU/VFIO/KVM 三方协作）

```text
1. open("/dev/vfio/vfio")            → 拿到 container fd
2. open("/dev/vfio/43")              → 拿到 group fd, 校验 group viable
3. VFIO_GROUP_GET_DEVICE_FD          → 拿到 VF 的 device fd
4. VFIO_IOMMU_MAP_DMA (逐段)          → 把 guest 全部 RAM 注册进来:
     - pin_user_pages(): 宿主机物理页全部锁死（不可换出/迁移）
     - 在 VT-d 页表写入 GPA→HPA 映射
     - 从此网卡 DMA 用的"地址"经 IOMMU 翻译后只能落在 guest 内存
5. VF BAR (MMIO 区域) mmap 进 guest 物理地址空间 (KVM memory slot)
     → guest 驱动写 doorbell = 直接写硬件寄存器, 无 VM Exit
6. VFIO_DEVICE_SET_IRQS + irqfd    → VF 的 MSI-X 向量接进 KVM
     → 配合 posted-interrupt, 中断直接投递给 vCPU, 无 VM Exit
```

### 宿主机上多了什么 / 怎么看

```bash
# (1) qemu 进程持有 vfio fd
$ ls -l /proc/$(pgrep -f qemu-system)/fd | grep vfio
l-wx------ 1 root root 64 ... 24 -> /dev/vfio/vfio
lrwx------ 1 root root 64 ... 27 -> /dev/vfio/43

# (2) guest 内存被 pin：qemu RSS ≈ guest RAM 大小
$ ps -o pid,rss,cmd -p $(pgrep -f qemu-system)
  PID     RSS CMD
 4242 8421376 qemu-system-x86_64 ...     # ~8G

# (3) libvirt 管理的话
$ virsh list
 Id   Name      State
 1    vm-web1   running

# (4) host 的 /proc/interrupts 里看不到 VF 的中断——它们直接进 guest
```

---

## Step 7. Guest 内部：数据面跑起来

### Guest 里看到的

```bash
$ lspci
00:05.0 Ethernet controller: Intel Corporation 82599 Ethernet Controller Virtual Function

# guest 内核自动绑 VF 驱动（ixgbevf 在内核里，随 PCI ID 匹配）
$ ethtool -i eth1
driver: ixgbevf
version: 5.x.x-k

$ ip link show eth1
2: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> ...
    link/ether 52:54:00:12:34:56 ...     ← 正是 host 在 Step 4 设置的 MAC

$ ip addr add 10.0.0.5/24 dev eth1
$ ping 10.0.0.1                          # 通!
$ cat /proc/interrupts | grep ixgbevf    # 能看到 VF 的 MSI-X 向量计数在涨
```

### 收发一个包的完整路径（为什么快）

```text
发送:
guest 驱动填发送描述符(在 guest 内存)
 → 写 doorbell 寄存器 (VF BAR MMIO, 已直通 → 不触发 VM Exit)
 → 网卡按描述符里的地址发 DMA 读
 → IOMMU 把 GPA 翻译成 HPA (硬件页表, host CPU 不参与)
 → 包从物理口发出

接收:
物理口收到目的 MAC=52:54:00:12:34:56 的包
 → eSwitch 查表 → 属于 VF0, 且 spoofchk/VLAN 检查通过
 → DMA 写进 guest 预挂的接收缓冲
 → 发 MSI-X → posted-interrupt 直接打断 vCPU
 → guest 的 ixgbevf 中断处理收包

整个数据路径: 0 次 VM Exit, 0 个 host 线程参与, host CPU 占用 ≈ 0
```

对比：virtio 路径每批包至少一次 notify 陷出 + vhost 线程 memcpy，
这就是 SR-IOV 在小包 PPS 和延迟上碾压软件方案的原因。

---

## Step 8. 拆除

```bash
# VM 关机 → qemu 退出 → vfio fd 关闭
#   → IOMMU 映射拆除, pinned 页全部释放 (ps 里 RSS 消失)

echo 0000:04:10.0 > /sys/bus/pci/drivers/vfio-pci/unbind   # 可选
echo 0 > /sys/class/net/eth0/device/sriov_numvfs
```

**逐项消失**（Step 3 的完全逆过程）：

- `lspci | grep -i virtual` → 无输出
- `/sys/bus/pci/devices/0000:04:10.*` → 目录删除
- PF 下 `virtfn*` symlink → 删除
- `/dev/vfio/43..50` → 删除
- `/sys/kernel/iommu_groups/` 数量 → 还原为 42
- udev → 收到 8 条 remove 事件
- dmesg → `ixgbe 0000:04:00.0: SR-IOV disabled`

一切归零，就像什么都没发生过——**所有状态都是内存态，重启后同样归零**。

---

## 汇总表：每步的"命令 → 内核路径 → 系统变化 → 观察方法"

| 步骤 | 触发命令 | 内核路径 | 新增/变化的系统对象 | shell 观察 |
|---|---|---|---|---|
| 1 开机 IOMMU | cmdline `intel_iommu=on` | DMAR 解析→group 划分 | `/sys/kernel/iommu_groups/*`、`/dev/vfio/vfio` | `ls /sys/kernel/iommu_groups \| wc -l` |
| 2 PF 驱动 | `modprobe ixgbe` | `ixgbe_probe`→注册 netdev | `driver` symlink、`/sys/class/net/eth0` | `lspci -ks`、`ip link` |
| 3 建 VF | `echo 8 > sriov_numvfs` | `pci_enable_sriov`→硬件写 VF Enable→重新枚举 | 8 个 `/sys/bus/pci/devices/*` 目录、`virtfn*`/`physfn` symlink、8 个新 iommu group、dmesg、udev add | `lspci \| grep -i virtual`、`udevadm monitor` |
| 4 控制面 | `ip link set ... vf 0` | netlink→`ndo_set_vf_*`→硬件表 | **无新文件**；`ip link` 输出多出 vf 行 | `ip link show eth0` |
| 5 绑 vfio | `driver_override`+`drivers_probe` | `vfio_pci_probe` | `/dev/vfio/<group>` 字符设备 | `ls -l /dev/vfio/` |
| 6 起 VM | qemu `-device vfio-pci` | MAP_DMA(pin页)+BAR mmap+irqfd | qemu 进程 fd 指向 `/dev/vfio/*`；RSS≈guest RAM | `ls -l /proc/<pid>/fd`、`ps` |
| 7 guest 数据面 | guest 内核枚举 | 绑 `ixgbevf`→netdev | guest 内新 netdev、`/proc/interrupts` 计数 | guest 里 `ethtool -i`、`ping` |
| 8 拆除 | `echo 0 > sriov_numvfs` | `pci_disable_sriov` | Step 3 全部逆向消失 | 各命令输出还原 |

---

## 常见"运行不起来"时查什么

| 症状 | 大概率原因 | 查证命令 |
|---|---|---|
| `write error: No such device` | PF 没绑驱动，或驱动不支持 sriov_configure | `lspci -ks <PF>` |
| `write error: Operation not supported` | 固件没开 SR-IOV / totalvfs=0 | `cat sriov_totalvfs`；网卡固件设置 |
| VF 和 PF 挤在同一个 iommu group | 上游 PCIe 口缺 ACS | `find /sys/kernel/iommu_groups/ -type l`；`lspci -vvv \| grep ACSCtl` |
| qemu 报 `Failed to mmap ... IOMMU` | 没开 intel_iommu 或 group 不完整 | Step 0 的 (b)(c) |
| guest 里收不到包 | VLAN/spoofchk/MAC 配置不匹配 | host `ip link show eth0` 对照 guest `ip link` |
| VF 建了但 guest 无驱动 | guest 内核缺 ixgbevf/iavf | guest `modprobe ixgbevf` |
