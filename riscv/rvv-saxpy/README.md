# RISC-V RVV saxpy 实验

用 C 调用**手写的 RISC-V 向量（RVV）汇编**实现的 SAXPY 内核（`y = a*x + y`），
在 Spike / QEMU 上编译运行并验证结果。

> 位置：`riscv/rvv-saxpy/`（`riscv/` 下后续还会放其他实验）

## 文件说明

```
riscv/rvv-saxpy/
├── README.md
├── a.c          C 驱动程序，调用 saxpy(3, 1.0, array1, array2)
├── a.s          手写的 RVV 汇编实现（vsetvli 分块循环 + vfmacc）
├── a.o          a.s 的汇编产物
├── call_a.o     a.c 的编译产物
├── out          上述两者静态链接后的可执行文件（Spike 运行目标）
├── hello.c      不含 saxpy 的测试程序源码
├── hello        动态链接版本（qemu-user 运行）
└── hello_static 静态链接版本（spike 运行）
```

| 文件 | 说明 |
|---|---|
| `a.c` | C 驱动程序，调用 `saxpy(3, 1.0, array1, array2)` |
| `a.s` | 手写的 RVV 汇编实现（`vsetvli` 分块循环 + `vfmacc`） |
| `a.o` / `call_a.o` | `a.s` 的汇编产物 / `a.c` 的编译产物 |
| `out` | 上述两者静态链接后的可执行文件（Spike 运行目标） |
| `hello.c` / `hello` / `hello_static` | 不含 saxpy 的测试程序，用于验证工具链（动态/静态各一份） |

## 快速开始

```bash
export PATH=/opt/riscv64/bin:$PATH

riscv64-unknown-linux-gnu-gcc -march=rv64imacv -mabi=lp64d -c a.s -o a.o
riscv64-unknown-linux-gnu-gcc -march=rv64imacv -mabi=lp64d -c a.c -o call_a.o
riscv64-unknown-linux-gnu-gcc -march=rv64imacv -mabi=lp64d -static call_a.o a.o -o out

spike --isa=RV64IMACV pk ./out    # 或 qemu-riscv64 ./out
```

## 环境准备

工具链位于 `/opt/riscv64`（riscv-gnu-toolchain，GCC 16.1.0，默认 `-march` 已包含 V 扩展）。

```bash
export PATH=/opt/riscv64/bin:$PATH
```

Spike 本身只模拟 CPU，需要配套的代理内核 `pk` 提供系统调用服务。

> **关于历史上的 "hack"**：`spike pk ./out` 中的 `pk` 并不是从 PATH 里查找的，
> spike 会直接打开**写死的相对路径** `<spike目录>/../riscv64-unknown-elf/bin/pk`
> （strace 实证：`openat(AT_FDCWD, "/opt/riscv64/bin/../riscv64-unknown-elf/bin/pk")`）。
> 本工具链只安装了 `riscv64-unknown-linux-gnu`（没有 `riscv64-unknown-elf`），
> 于是早期用 `sudo cp -r riscv64-unknown-linux-gnu riscv64-unknown-elf`
> 复制了一份目录来"骗过" spike（两处的 pk 是同一个文件，纯属占位，浪费了 ~218MB）。

其实不必复制整个目录，任选其一：

```bash
# 方案 A（推荐）：直接给 pk 的完整路径，绕过 spike 的路径约定
spike --isa=RV64IMACV /opt/riscv64/riscv64-unknown-linux-gnu/bin/pk ./out

# 方案 B：只建目录 + 软链一个 pk 文件，让 `spike pk ...` 的写法继续可用
sudo mkdir -p /opt/riscv64/riscv64-unknown-elf/bin
sudo ln -s ../../riscv64-unknown-linux-gnu/bin/pk /opt/riscv64/riscv64-unknown-elf/bin/pk
```

（本环境已按旧 hack 复制过目录，`spike pk ./out` 可直接使用。）

## 构建

```bash
# 1. 汇编 RVV 内核
riscv64-unknown-linux-gnu-gcc -march=rv64imacv -mabi=lp64d -c a.s -o a.o

# 2. 编译 C 驱动
riscv64-unknown-linux-gnu-gcc -march=rv64imacv -mabi=lp64d -c a.c -o call_a.o

# 3. 静态链接（注意：Spike 只能运行静态链接的 ELF）
riscv64-unknown-linux-gnu-gcc -march=rv64imacv -mabi=lp64d -static call_a.o a.o -o out
```

`hello` 系列同理：

```bash
riscv64-unknown-linux-gnu-gcc -o hello hello.c          # 动态链接（~9KB）
riscv64-unknown-linux-gnu-gcc -static -o hello_static hello.c   # 静态链接（~730KB）
```

## 运行

### 方式一：Spike + pk（静态程序，指令级精确模拟，支持 RVV）

```bash
spike --isa=RV64IMACV pk ./out
```

Spike 会拒绝动态链接的 ELF（报错 `not a statically linked ELF program`），
所以动态程序请用方式二。

### 方式二：QEMU user-mode（动态/静态均可，速度快）

```bash
qemu-riscv64 ./out                                  # 静态程序，不需要 sysroot
qemu-riscv64 -L /opt/riscv64/sysroot ./hello        # 动态程序：-L 指定 sysroot，
                                                    # qemu 在其中查找 ld-linux 和 libc.so.6
```

> **注意**：本工具链 sysroot 里的 glibc 2.44，其动态加载器 `ld.so` 启动时就会执行
> 向量指令 `vsetivli`。Ubuntu 22.04/24.04 打包的 qemu-user 未编译 RVV 支持，
> 运行动态程序会直接 SIGILL。请使用带 RVV 的新版 qemu
> （本机做法：解压 Ubuntu 新版本的 `qemu-user` 包，将其中的静态二进制
> `qemu-riscv64` 放到 `~/.local/bin/`，无需 root）。

## 结果

```
$ spike --isa=RV64IMACV pk ./out
1.000000
2.000000
3.000000
----------------
2.000000
4.000000
6.000000
```

即 `y = 1.0 * x + y` 计算正确。

## saxpy 汇编速览

```asm
saxpy:
    vsetvli   a4, a0, e32, m8, ta, ma   # 按剩余元素数 n 设置 vl（32位浮点，LMUL=8）
    vle32.v   v0, (a1)                  # 加载 x
    sub       a0, a0, a4                # 剩余数量 -= vl
    slli      a4, a4, 2                 # vl * 4 字节 = 本块字节数
    add       a1, a1, a4                # x 指针前进
    vle32.v   v8, (a2)                  # 加载 y
    vfmacc.vf v8, fa0, v0                # v8 = fa0 * v0 + v8  → y += a*x
    vse32.v   v8, (a2)                  # 存回 y
    add       a2, a2, a4                # y 指针前进
    bnez      a0, saxpy                 # 处理剩余元素（分块循环）
    ret
```

## 排障速查（本环境踩过的坑）

| 症状 | 原因 | 解决 |
|---|---|---|
| `spike pk ./out` 找不到 pk | spike 只认写死路径 `../riscv64-unknown-elf/bin/pk`，不查 PATH | 用 pk 完整路径，或建目录软链（见"环境准备"） |
| `spike pk ./hello` 报 `not a statically linked ELF program` | pk 只支持静态 ELF，无法运行动态链接程序 | 动态程序改用 qemu-user |
| qemu 运行动态程序一启动就 SIGILL（exit 132） | sysroot 里 glibc 2.44 的 `ld.so` 启动即执行向量指令 `vsetivli`，而 Ubuntu 打包的 qemu-user 未编译 RVV 支持 | 换带 RVV 的新版 qemu（本机为解压的 qemu 9.2 静态二进制） |
