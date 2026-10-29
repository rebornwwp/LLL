# IOMMU 技术笔记

## 一句话

**IOMMU（Input-Output Memory Management Unit）** 是位于 **I/O 设备与内存之间的硬件地址转换单元**：就像 MMU 为进程做虚拟地址→物理地址的转换，IOMMU 为 **设备的 DMA 访问** 做 IOVA（IO 虚拟地址）→物理地址的转换，并附带权限检查与隔离。

主流实现：Intel **VT-d**、AMD **AMD-Vi**、ARM **SMMU**、RISC-V **IOMMU**。

---

## 它要解决的问题

没有 IOMMU 时，设备 DMA 直接使用**物理地址**：

| 问题 | 后果 |
|---|---|
| 设备 DMA 用裸物理地址 | 直通给 VM 的设备可以读写**整个主机内存** → 一个 Guest 可以偷看/破坏其他 Guest 和 Host |
| 恶意外设（雷电接口、改装固件） | **DMA 攻击**：绕过 CPU 直接读内核内存，偷密钥、注入代码 |
| 32 位设备访问 64 位大内存 | 只能走 bounce buffer（低端内存中转拷贝），性能差 |
| 设备要求大块连续物理内存 | 物理内存碎片化后难以满足 |

IOMMU 等于给 DMA 加上 **"虚拟内存 + 权限检查"**，以上问题一并解决。

> DMA 基础概念见 [dma.md](dma.md)。

---

## 核心功能

### 1. DMA 重映射（DMA Remapping）

```text
设备发出 DMA 请求（IOVA）
        │
        ▼
   ┌─────────┐   按 BDF 查上下文表 → 找到该设备的 IO 页表
   │  IOMMU  │   多级页表逐级转换（IOTLB 缓存加速）
   └────┬────┘
        ▼
   物理地址（HPA）  ←── 无映射/无权限 → IOMMU fault，访问被阻断
```

- 每个设备（按 **BDF**，Bus:Device.Function）绑定一套独立的 IO 页表。
- Guest 直通场景下，页表内容是 **IOVA → GPA → HPA** 的两级映射（或合并为一级嵌套转换）。

### 2. 中断重映射（Interrupt Remapping）

设备发出的 MSI/MSI-X 不再直接写 LAPIC，而是先经 IOMMU 查 **IRTE 表** 重定向：

- 确保设备中断只能投递到**被授权的 vCPU**，防止 Guest 用伪造中断攻击 Host。
- 也是 VFIO 直通安全模型的一部分。

### 3. 隔离与保护

- 每个设备只能访问其 IO 页表中被映射的页面，越界访问触发 fault。
- fault 会在内核日志中留下 `DMAR: [DMA Read] ... fault` 之类的记录。

---

## 主要应用场景

| 场景 | 说明 |
|---|---|
| **虚拟机设备直通（VFIO Passthrough）** | 把物理网卡/GPU/NVMe 直通给 VM。IOMMU 保证该设备只能 DMA 到本 VM 的内存，是**安全直通的前提** |
| **SR-IOV VF 直通** | 每个 VF 是独立 BDF，各自绑定 IO 页表（见 [sriov.md](sriov.md)） |
| **用户态驱动（DPDK / SPDK）** | 通过 VFIO/UIO 在用户态直接驱动硬件，绕过内核协议栈 |
| **防 DMA 攻击** | 雷电/PCIe 外设的 DMA 被限制在驱动显式映射的缓冲区内 |
| **大内存寻址** | 32 位设备经重映射直接访问高位物理地址，免 bounce buffer |

---

## 工作原理细节

```text
DMA 请求到达 IOMMU
  │
  ├─ 1. 用 BDF 索引 Root Table → Context Table（找到设备上下文）
  │
  ├─ 2. 从上下文取出 IO 页表基址
  │
  ├─ 3. 查 IOTLB（转换缓存）
  │      ├─ 命中 → 直接得到物理地址
  │      └─ 未命中 → 走多级 IO 页表（page walk），结果填入 IOTLB
  │
  └─ 4. 权限检查（读/写位）→ 放行或 fault
```

关键概念：

- **IOTLB**：IOMMU 内部的转换缓存。驱动修改 IO 页表后必须发 **IOTLB invalidation**。
- **IO 页表**：格式与 CPU 页表类似（x86 上支持 4K/2M/1G 页），可与 EPT/NPT 组成**嵌套转换**（IOVA→GPA→HPA 一次走完）。
- **ATS（Address Translation Services）**：PCIe 特性，让设备自己缓存转换结果（设备内 ATC），减少 IOMMU 访问。
- **PRI（Page Request Interface）**：设备可向上请求"缺页"，配合 SVA 使用。
- **SVA / SVM（Shared Virtual Addressing）**：设备与进程**共享 CPU 页表**，设备直接访问 `malloc` 出来的虚拟地址，常用于加速器/GPU 场景。

---

## IOMMU Group：直通的最小隔离单位

Linux 按 **IOMMU group** 管理设备隔离边界：

- 同组设备之间**可能存在互相 DMA 的通道**（如经不带 ACS 的 PCIe 交换机、同一块多功能芯片），所以必须**整组一起直通**，不能拆开。
- 常见情况：一个 PCIe 插槽上的单功能设备 = 独立一组；经某些板载交换机/桥的多个设备 = 合并成一大组。

```bash
# 查看分组
ls /sys/kernel/iommu_groups/

# 查看某个组里有哪些设备
ls /sys/kernel/iommu_groups/1/devices/

# 查看某设备属于哪个组
readlink /sys/bus/pci/devices/0000:3b:00.0/iommu_group
```

> 想拆组？确认拓扑支持 **ACS**（Access Control Services），或用 `pcie_acs_override` 补丁（有风险，仅在确信无 P2P 通道时用）。

---

## 实操：Linux 启用与检查

```bash
# 1. 内核启动参数（GRUB_CMDLINE_LINUX）
intel_iommu=on iommu=pt        # Intel；pt = 仅对直通设备做转换，Host 驱动走恒等映射
amd_iommu=on iommu=pt          # AMD

# 2. 确认启用
dmesg | grep -i -e DMAR -e IOMMU
# 期望看到类似：DMAR: IOMMU enabled / AMD-Vi: ...

# 3. 确认中断重映射
dmesg | grep -i "interrupt remapping"

# 4. 直通时把设备绑到 vfio-pci
echo "0000:3b:00.0" > /sys/bus/pci/devices/0000:3b:00.0/driver/unbind
modprobe vfio-pci
echo "8086 10fb" > /sys/bus/pci/drivers/vfio-pci/new_id
```

关于 `iommu=pt`（passthrough 模式）：

- 不加：Host 上**所有**驱动的 DMA 都走 IOMMU 页表转换（更隔离，但有少量页表维护/IOTLB 开销）。
- 加 `pt`：Host 驱动使用恒等映射（IOVA=PA）跳过转换，**只有直通给 VM 的设备才走转换**。性能好，是虚拟化宿主机的常见选择。

---

## 与相关技术的关系

```text
                    ┌───────────────┐
   Guest 驱动 ──DMA──►│ 物理设备(VF/PF) │
                    └──────┬────────┘
                           │ IOVA
                           ▼
                    ┌──────────────┐
                    │    IOMMU     │  ← DMA 重映射 + 中断重映射
                    │ (VT-d/AMD-Vi)│  ← 隔离边界 = IOMMU group
                    └──────┬───────┘
                           ▼ HPA
                        物理内存
```

- **SR-IOV** 负责"切设备"（硬件层面分出 VF），**IOMMU** 负责"隔离 DMA"——两者配套使用，见 [sriov.md](sriov.md)。
- **VFIO** 是 Linux 暴露给用户态/QEMU 的接口，底层隔离能力就来自 IOMMU。
- **EPT/NPT**（CPU 侧二级页表）解决 GPA→HPA；**IOMMU** 解决设备侧 IOVA→HPA，虚拟化里两者一起构成完整的地址翻译链。

---

## 常见问题速查

| 现象 | 排查 |
|---|---|
| `dmesg` 刷 DMAR fault | 某设备 DMA 越界：查对应 BDF，多是驱动 bug 或直通配置错 |
| VFIO 绑定报 "group is not viable" | 组内有设备未解绑/未绑 vfio-pci，整组处理 |
| 直通后性能差 | 检查是否忘了 `iommu=pt`；大页（hugepage）减少 IO 页表层级 |
| 组太大拆不开 | 查 ACS 支持；确认是否板载交换机导致 |
| BIOS 里开了 VT-d 但没生效 | 确认内核参数、`dmesg` 输出；有些主板拆分为 "VT-d" 和 "Interrupt Remapping" 两个开关 |

---

## 一句话总结

**IOMMU 就是给设备 DMA 加上了虚拟内存与权限检查**：设备不再直接摸物理内存，而是拿 IOVA 经过 IOMMU 翻译和鉴权。它是虚拟化直通（VFIO/SR-IOV）安全的基石，也是用户态高性能 I/O（DPDK/SPDK）和 DMA 攻击防护的底层支撑。
