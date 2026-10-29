# DMA 技术笔记

## 一句话

**DMA（Direct Memory Access，直接内存访问）** 是让 **外设不经过 CPU、直接读写内存** 的技术：CPU 只负责"下指令"和"收通知"，数据搬运过程完全不参与。它是所有现代高速 I/O（网卡、磁盘、GPU）的性能基础。

---

## 它要解决的问题

没有 DMA 时，数据传输全靠 CPU 逐字节搬运（**PIO 模式**，Programmed I/O）：

```text
磁盘 ──► CPU 寄存器 ──► 内存      ← 每个字节都要 CPU 经手
```

- 读 1GB 文件，CPU 就被搬运占用 1GB 的时间，几乎干不了别的
- 中断频繁（每来一小段数据就打断 CPU），高速设备根本跑不满

有了 DMA：

```text
CPU: "把磁盘 X 扇区的数据搬到内存 Y 地址，搬完叫我"
       │
       ▼
设备/DMA 控制器 ══直接搬运══► 内存     ← CPU 同时去干别的活
       │
       ▼
   搬完了，中断通知 CPU
```

**CPU 从"搬运工"变成"监工"。**

---

## 两种形态

| 形态 | 说明 | 典型场景 |
|---|---|---|
| **DMA 控制器（DMAC）** | 一个专门的硬件引擎帮忙搬运，多个通道可服务不同外设 | SoC / 嵌入式（ARM PL330、STM32 DMAC）、内存到内存拷贝（ioat） |
| **Bus Mastering DMA** | 设备自己当总线主控，直接发起内存读写事务 | **现代 PCIe 设备全是这种**：网卡、GPU、NVMe、xHCI |

> 笔记主要关注第二种——服务器/PC 场景下的主流。

---

## 工作流程（以网卡收包为例）

```text
┌─────────────────────────────────────────────────────┐
│ 1. 驱动分配 DMA 缓冲区（描述符环 + 数据 buffer）      │
│    把缓冲区的"DMA 地址"写进设备寄存器/描述符          │
├─────────────────────────────────────────────────────┤
│ 2. 网卡收到数据包                                    │
│    网卡自己发起总线写事务 ──► 数据直接落入内存 buffer │
├─────────────────────────────────────────────────────┤
│ 3. 网卡更新描述符状态，发 MSI-X 中断                  │
├─────────────────────────────────────────────────────┤
│ 4. CPU 响应中断，直接从内存取包处理（零拷贝路径）      │
└─────────────────────────────────────────────────────┘
```

发包（TX）对称：CPU 把数据放进 buffer、填描述符、敲 doorbell，设备自己从内存读走数据发出去。

---

## 关键概念

### DMA 地址 ≠ 物理地址

驱动给设备的地址叫 **DMA 地址（总线地址）**：

- 无 IOMMU 或 `iommu=pt` 时：DMA 地址 ≈ 物理地址
- 有 IOMMU 转换时：DMA 地址 = **IOVA**，经 IOMMU 翻译才到物理内存（见 [iommu.md](iommu.md)）

### Scatter-Gather（分散-聚集）

一次 DMA 事务可以操作**多块不连续**的内存：

```text
设备一次操作：  [buf A: 0x1000, 4K] + [buf B: 0x9000, 2K] + [buf C: 0x3000, 8K]
```

好处：不要求大块连续物理内存（避免内存碎片问题），网卡/磁盘驱动大量使用。

### Cache 一致性

```text
问题：设备 DMA 写了内存，但 CPU 缓存里还是旧数据（或反过来）
```

| 架构 | 处理方式 |
|---|---|
| **x86** | 硬件保证 DMA 与 CPU cache 一致（snoop），驱动基本不用管 |
| **ARM / RISC-V** | 很多场景**不保证**，驱动必须显式做 cache flush（DMA 前）/ invalidate（DMA 后），或使用 non-cacheable 缓冲区 |

### 一致性 DMA vs 流式 DMA（Linux 术语）

| 类型 | API | 特点 |
|---|---|---|
| **一致性（coherent）** | `dma_alloc_coherent()` | 长期使用的缓冲区（如描述符环），分配一次用到底 |
| **流式（streaming）** | `dma_map_single()` / `dma_unmap_single()` | 临时映射一块已有内存给设备用，用完即解除，带方向参数（TO_DEVICE / FROM_DEVICE） |

### Zero-Copy（零拷贝）

DMA 的高级玩法：数据从网卡/磁盘**直达目标缓冲区**，内核全程不搬不拷。代表技术：DPDK（用户态收包）、`sendfile`、`io_uring`、GPU Direct RDMA。

---

## 代码示例：Python 模拟 DMA 工作流程

用户态程序无法真正发起 DMA（那是硬件+内核的事），但可以用线程模拟各硬件角色，直观感受区别。完整脚本见 [dma-demo/dma_simulation.py](dma-demo/dma_simulation.py)，直接 `python3` 运行即可。

核心思路：

```python
# PIO:CPU 自己逐字节搬,期间无法干别的
for i, byte in enumerate(disk):
    memory[i] = byte            # 每字节都是 CPU 指令

# DMA:CPU 填描述符 → 启动控制器线程 → 自己先去干别的
dmac = DMAController(desc)      # 描述符 = (源, 目的, 长度)
dmac.start()                    # 敲 doorbell
cpu_do_other_work()             # CPU 立刻脱身
dma_done.wait()                 # 等"中断"通知
```

实际运行输出（时间线节选），注意两种方式里 **CPU 干其他活的时机**：

```text
方式一 PIO:
[  0.0ms] [ CPU  ] 开始从磁盘读数据到内存(PIO 模式)
[ 10.1ms] [ CPU  ] 搬运字节[ 0]: 'H'
   ...（16 字节全由 CPU 搬完）
[161.4ms] [ CPU  ] 搬运完成,但期间别的任务一点没干成!
[171.4ms] [ CPU  ] 处理其他任务中... (1/3)   ← 别的活只能排到最后

方式二 DMA:
[241.7ms] [ CPU  ] 填写描述符,敲 doorbell,启动 DMA
[252.1ms] [ CPU  ] 处理其他任务中... (1/3)   ← CPU 立刻脱身
[252.1ms] [ DMAC ] 搬运字节[ 0] (CPU 无感知) ← 控制器后台搬
[262.2ms] [ CPU  ] 处理其他任务中... (2/3)
   ...
[403.4ms] [ DMAC ] 搬运完成 → 触发中断通知 CPU
[403.5ms] [ CPU  ] 收到中断!内存: b'HELLO-DMA-WORLD!'
```

> 想看**真实的 DMA 驱动代码**，那就是内核模块了（`dma_alloc_coherent()` / `dma_map_single()` 这套 API），需要在装了内核头文件的 Linux 机器上编译，WSL 环境跑不了。

---

## Linux 中的观察与调试

```bash
# 查看 DMA 相关设备
ls /sys/class/dma/                    # DMAC 通道（多见于嵌入式/ioat）

# 查看设备的 DMA 掩码（能寻址多少位内存）
cat /sys/bus/pci/devices/0000:3b:00.0/dma_mask_bits

# DMA API 调试（需 CONFIG_DMA_API_DEBUG，能抓驱动漏 unmap、越界等）
# 内核启动参数：
dma_debug=on

# 32 位设备访问大内存时的 bounce buffer 机制
dmesg | grep -i swiotlb
```

---

## 与 IOMMU 的关系

DMA 的"直接访问内存"是一把双刃剑：

- ✅ **快**：绕开 CPU，吞吐拉满、延迟降低
- ⚠️ **危险**：设备能用物理地址读写**任意内存**
  - 坏驱动 → 踩坏内核内存，玄学崩溃
  - 恶意外设 → **DMA 攻击**（雷电接口设备直接读内存偷密钥）

```text
                    ┌──────────────┐
   设备 ──DMA(IOVA)──►│    IOMMU     │──► 物理内存
                    │ 翻译 + 鉴权   │    （只允许访问被授权的页面）
                    └──────────────┘
```

IOMMU 就是给 DMA 这条路加上的**安检门**：设备发 DMA 时不再直接用物理地址，而是用 IOVA，由 IOMMU 翻译和鉴权。详见 [iommu.md](iommu.md)。

---

## 常见问题速查

| 现象 | 可能原因 |
|---|---|
| 高速网卡 CPU 占用高、速率上不去 | 没走 DMA/零拷贝路径；中断未亲和；GRO/LRO 未开 |
| ARM 上 DMA 数据是旧的/脏的 | cache 未 flush/invalidate，流式 DMA 方向参数传错 |
| 大内存机器上老设备 DMA 失败 | 设备 DMA 掩码只有 32 位，走了 swiotlb bounce buffer，检查 `iommu=pt` 或设备固件 |
| `dma_debug` 报漏 unmap | 驱动 bug：流式 DMA 映射后忘记 `dma_unmap_*` |

---

## 一句话总结

**DMA 让设备自己搬数据，CPU 只管指挥**——这是现代 I/O 性能的根基；而 DMA 越自由越危险，所以有 IOMMU 给它画边界。理解 DMA（总线地址、scatter-gather、cache 一致性）是看懂网卡/存储驱动和虚拟化直通的第一步。
