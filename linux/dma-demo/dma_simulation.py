#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
DMA 概念模拟脚本
================
用线程模拟硬件角色,直观对比两种数据传输方式:

  1. PIO 模式:CPU 逐字节搬运,搬运期间无法干别的活
  2. DMA 模式:CPU 只下命令,DMA 控制器在后台搬运,
              CPU 同时处理别的任务,完成后收到"中断"通知

运行: python3 dma_simulation.py
"""

import threading
import time

# ─────────────────────────────────────────────
# 模拟硬件:内存 和 磁盘
# ─────────────────────────────────────────────
MEM_SIZE = 64          # 内存大小(字节)
memory = bytearray(MEM_SIZE)          # 物理内存
disk = b"HELLO-DMA-WORLD!"            # 磁盘上的数据(16 字节)

# 全局时钟,方便看时间线
_t0 = time.monotonic()
def log(role, msg):
    t = (time.monotonic() - _t0) * 1000
    print(f"[{t:7.1f}ms] [{role:^6s}] {msg}")


def cpu_do_other_work(n=3):
    """模拟 CPU 处理别的任务"""
    for i in range(n):
        time.sleep(0.01)
        log("CPU", f"处理其他任务中... ({i+1}/{n})")


# ═════════════════════════════════════════════
# 方式一:PIO —— CPU 亲自逐字节搬运
# ═════════════════════════════════════════════
def demo_pio():
    print("=" * 60)
    print("方式一:PIO(CPU 亲自搬运,全程被占用)")
    print("=" * 60)
    log("CPU", "开始从磁盘读数据到内存(PIO 模式)")
    for i, byte in enumerate(disk):
        time.sleep(0.01)                       # 每搬 1 字节都要 CPU 执行指令
        memory[i] = byte
        log("CPU", f"搬运字节[{i:2d}]: {chr(byte)!r}")
    log("CPU", "搬运完成,但期间别的任务一点没干成!")

    # CPU 想干别的活?只能等搬完:
    cpu_do_other_work()
    print()


# ═════════════════════════════════════════════
# 方式二:DMA —— CPU 下命令,控制器搬运
# ═════════════════════════════════════════════
dma_done = threading.Event()                   # "中断"信号

class DMAController(threading.Thread):
    """DMA 控制器:收到描述符后独立搬运数据,完成后发中断"""

    def __init__(self, desc):
        super().__init__()
        self.desc = desc                       # DMA 描述符:源、目的、长度

    def run(self):
        src, dst, length = self.desc
        log("DMAC", f"收到描述符: src=磁盘 dst=内存[{dst:#x}] len={length}")
        for i in range(length):
            time.sleep(0.01)                   # 控制器自己搬,不占 CPU
            memory[dst + i] = disk[i]
            log("DMAC", f"搬运字节[{i:2d}] (CPU 无感知)")
        log("DMAC", "搬运完成 → 触发中断通知 CPU")
        dma_done.set()                         # 发出"中断"


def demo_dma():
    print("=" * 60)
    print("方式二:DMA(CPU 下命令后去干别的,控制器后台搬运)")
    print("=" * 60)

    # 1. CPU 填写描述符,写好 doorbell,启动 DMA
    desc = (0, 0x20, len(disk))                # (源, 目的地址, 长度)
    dmac = DMAController(desc)
    log("CPU", "填写描述符,敲 doorbell,启动 DMA")
    dmac.start()

    # 2. CPU 立刻脱身,去干别的活 ← 这就是 DMA 的核心价值
    cpu_do_other_work()

    # 3. 等"中断"到达
    dma_done.wait()
    log("CPU", f"收到中断!检查内存[{0x20:#x}]: "
               f"{bytes(memory[0x20:0x20+len(disk)])!r}")
    dmac.join()


if __name__ == "__main__":
    demo_pio()
    time.sleep(0.05)
    demo_dma()
    print()
    print("结论:PIO 时 CPU 是搬运工;DMA 时 CPU 是监工——")
    print("      下完命令就去干别的,搬完由中断通知。")
