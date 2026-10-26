# SR-IOV 技术笔记

## 一句话

**SR-IOV（Single Root I/O Virtualization）** 是 PCI-SIG 定义的一个硬件虚拟化标准：**让一块物理 PCIe 设备（网卡、GPU、NVMe、FPGA……）在硬件层面把自己切分成多个"虚拟设备"**，每个虚拟设备可以直接分配给一个虚拟机或容器，数据收发走硬件 DMA 直通、几乎不经过 Hypervisor（管理/配置仍由 Host 上的 PF 驱动负责）。

---

## 它要解决的问题

虚拟机的 I/O 通常有三条路：

| 方式 | 数据路径 | 性能 | 问题 |
|---|---|---|---|
| **模拟设备**（如 e1000） | 每次访问触发 VM Exit，Hypervisor 模拟 | 差 | CPU 开销巨大 |
| **virtio / vhost-user** | 共享内存环 + 通知，仍有陷出与 vhost 线程 | 好 | 还有软件栈开销，需驱动配合 |
| **PCI 直通（VFIO passthrough）** | 硬件 DMA 直通 | 接近裸机 | **一块卡只能给一个 VM，独占** |

SR-IOV 等于：**硬件级切分 + 直通**，既保留接近裸机的性能，又不用一块卡只服务一个 VM。

---

## 核心概念：PF 与 VF

```text
        ┌──────────────────────────────┐
        │   Physical PCIe Device       │
        │  ┌────────┐                  │
        │  │   PF   │ ← 完整功能，驱动在 Host
        │  └───┬────┘                  │
        │      │ 硬件切分               │
        │  ┌───┴──┬──────┬──────┐      │
        │  │ VF0  │ VF1  │ VF2  │ ...  │  ← 每个 VF 是一个独立 PCI 功能
        │  └───┬──┴───┬──┴───┬──┘      │
        └──────┼──────┼──────┼─────────┘
               │      │      │
             VM-A   VM-B   VM-C        ← 各自绑定 VFIO 直通
```

- **PF（Physical Function）**：拥有设备的完整配置能力（PCI 配置空间、寄存器、管理接口）。Host 上的 PF 驱动负责创建/管理 VF。
- **VF（Virtual Function）**：轻量级 PCI 功能，只暴露收发/计算所需的最小寄存器集，**没有完整的配置能力**。对 Guest 来说，它就是一个普通 PCI 设备。

关键点：**VF 是真实的 PCI 设备**，有独立的 BDF（Bus:Device.Function）、独立 BAR、独立 MSI-X 中断。所以 Guest 里能直接 `lspci` 看到它，用原生厂商驱动（如 Intel 的 `ixgbevf`/`iavf`、Mellanox 的 `mlx5_core`（PF/VF 通用）、NVMe 的 `nvme` 等）。

---

## 数据面 vs 控制面

```text
控制面（慢路径）：Host PF 驱动 / iproute2
   设置 VF 数量、MAC、VLAN、速率、信任模式、spoofchk、ACL
        │
        ▼
数据面（快路径）：Guest 驱动 ⟨──直接 DMA──⟩ 网卡硬件 ⟨──⟩ 物理网络
   Hypervisor 完全不参与收发
```

- **收发包**：Guest 驱动直接操作 VF 的队列，硬件 DMA 进出 Guest 内存。**零 VM Exit、零 vhost 线程**。
- **隔离**：靠 **IOMMU**（Intel VT-d / AMD-Vi）做 DMA 重映射，VF 只能 DMA 到自己被授权的内存。所以 SR-IOV 通常**必须有 IOMMU**，否则就是 DMA 攻击面。
- **中断**：VF 有独立 MSI-X 向量，直接注入 Guest（配合 posted interrupt / APICv 更省）。

---

## 硬件/系统需要的支持

1. **CPU + 芯片组**：VT-d / AMD-Vi（IOMMU），且 BIOS 里打开。
2. **设备本身**：支持 SR-IOV，且固件（网卡 firmware / GPU VBIOS）开启 VF 能力。
3. **PCIe 拓扑**：
   - **ACS（Access Control Services）**：保证 VF 之间、VF 到上游的 P2P 流量被正确隔离。没有 ACS 的交换机/根端口可能导致 VF 互相访问，或必须把设备放进同一 IOMMU group 而无法单独直通。
   - **ARI（Alternative Routing-ID Interpretation）**：让一个设备能暴露超过 8 个 Function（否则 BDF 的 3 bit function 号不够用）。
4. **Hypervisor/Kernel**：VFIO、`vfio-pci`、KVM 的 VF 支持；容器场景还需 SR-IOV Device Plugin。

---

## 实操：Linux 上大概长这样

```bash
# 1. 确认设备支持（看是否有 Single Root I/O Virtualization 能力）
lspci -vvv -s 0000:3b:00.0 | grep -A 20 "Single Root"
cat /sys/class/net/eth0/device/sriov_totalvfs   # 硬件支持的最大 VF 数

# 2. 创建 8 个 VF（PF 驱动需要支持；Intel 卡常见）
echo 8 > /sys/class/net/eth0/device/sriov_numvfs

# 3. 看看生成了什么
lspci | grep -i "virtual function"
ip link show

# 4. 给 VF 配 MAC / VLAN / 防欺骗（控制面）
ip link set eth0 vf 0 mac 52:54:00:12:34:56
ip link set eth0 vf 0 vlan 100
ip link set eth0 vf 0 spoofchk on
ip link set eth0 vf 0 trust off

# 5. 直通给 QEMU/KVM（把 VF 的 BDF 传给 VM）
#    -device vfio-pci,host=3b:02.0
```

Kubernetes 里则是：**SR-IOV Network Operator + Device Plugin + Multus CNI + sriov-cni**，把 VF 当成可调度资源（`intel.com/sriov_netdevice: 1`）。

---

## 优缺点

**优点**

- 网络性能接近裸机：小包 PPS 高、延迟低、抖动小，CPU 占用极低。
- 支持 **DPDK / XDP / RDMA（RoCEv2）** 等需要直接操作硬件的场景。
- 一块卡可服务多个租户/VM，成本分摊。
- VF 是标准 PCI 设备，Guest 用原生驱动即可，兼容性好。

**缺点与限制**

- **VF 数量受硬件限制**（常见几十到上百个，如 Intel 82599 是 63 个、E810 可到 256 个，不是无限的），且 VF 是"粗粒度"切分——每个 VF 至少带一套队列和 BAR，切太细不划算。
- **Live Migration 困难**：VF 绑定物理硬件状态，传统上不能热迁移。虽有 **SR-IOV Migration Capability**（PF 帮忙保存/恢复 VF 状态）在推进，但生态支持参差。
- **管理面变复杂**：MAC/VLAN/ACL/spoofchk/trust 要靠 PF 侧配置，Hypervisor 失去对流量的可见性——**监控、防火墙、QoS 都要下移到网卡或交换机**。
- **安全边界更硬也更脆**：靠 IOMMU + ACS；配错了（关掉 spoofchk、缺 ACS、VF 之间 P2P）就是漏洞。
- **厂商依赖强**：PF 驱动、firmware、VF 数量、是否允许 VF 用于 RDMA 等，各卡差异大。
- 对 **overlay 网络**不友好：VF 直通后 Guest 直接看到物理网卡，VXLAN 封装要么靠网卡硬件 offload，要么回退到软件。

---

## 和相邻技术的对比

| 技术 | 粒度 | 性能 | 迁移 | 典型场景 |
|---|---|---|---|---|
| **virtio-net + vhost** | 软件，任意多 | 好 | ✅ 容易 | 通用云主机 |
| **vhost-user + DPDK** | 软件，任意多 | 很好 | ⚠️ 较难 | NFV、高性能网关 |
| **PCI Passthrough（整卡）** | 1 卡 = 1 VM | 裸机 | ❌ | GPU 训练、专用加速卡 |
| **SR-IOV** | 硬件切分，VF 数固定 | ≈裸机 | ⚠️ 有限支持 | 高性能网络、NFV、多租户 GPU 分片 |
| **Scalable IOV (SIOV)** | 更细粒度（可到数百/数千） | ≈裸机 | 设计上更好 | 下一代，生态仍在成熟 |

> 补充：**SIOV（Scalable I/O Virtualization）** 是 Intel 提出的规范（基于 PCIe 的 PASID 等能力），用"共享工作队列 + 每 VM 一个 PASID 地址空间"取代"每个 VF 一套完整 PCI 功能"，切分粒度更细、可扩展性更好，被认为是 SR-IOV 的演进方向。另外 **NVIDIA MIG** 是 GPU 厂商自己的粗粒度切分方案，思路类似但不等同于 SR-IOV。

---

## 典型落地场景

- **电信 NFV / 5G UPF**：SR-IOV + DPDK，线速转发，最经典的用法。
- **公有云高性能实例**：AWS ENA、Azure Accelerated Networking、阿里云部分规格，本质都是 SR-IOV 变体。
- **Kubernetes 高性能 Pod**：SR-IOV CNI 给 Pod 一张"物理网卡"，跑 RDMA 或 DPDK 应用。
- **GPU 分片**：部分卡支持 SR-IOV VF（如 Intel Data Center GPU、部分 AMD），把 GPU 切给多个 VM。
- **NVMe**：支持 SR-IOV 的 NVMe 盘（NVMe 1.4+）可给每个 VM 直通一个 VF 控制器及其命名空间，绕过 host 存储栈。

---

## 一句话总结

SR-IOV 是"**硬件帮你把一块卡切成多块，每块都是真 PCI 设备，VM 直接驱动它**"——用硬件的复杂度换掉软件的 CPU 开销，代价是灵活性（VF 数量、迁移、可见性）和配置上的坑。

---

> 延伸阅读：
> - [sriov-runtime.md](./sriov-runtime.md) —— 运行时逐步解析（VM 直通主线）：每一步内核做了什么、shell 里能看到哪些文件/节点变化。
> - [sriov-example.md](./sriov-example.md) —— 对照真实博客案例的逐节走读（K8s 容器主线）：multus/sriov-cni/device-plugin 运行时序与文件级变化。
