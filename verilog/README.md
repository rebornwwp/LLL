# Verilog 学习笔记

记录 Verilog / iverilog 的学习过程。每条笔记尽量包含:可运行的代码、执行命令、背后发生了什么、常见坑。

## 0. 环境

```sh
iverilog -V     # 编译器版本,同时会打印 VPI 库路径
vvp -V          # 仿真运行时版本
```

当前环境:

```
Icarus Verilog 11.0 (stable)
安装路径: ~/.local/opt/iverilog/lib/x86_64-linux-gnu/ivl/
```

## 1. Hello World

`hello.v`

```verilog
module hello;
  initial
    begin
      $display("Hello, World");
      $finish ;
    end
endmodule
```

编译并运行:

```sh
iverilog -o hello hello.v
vvp hello
```

输出:

```
Hello, World
```

## 2. 这两步到底在干什么

关键认知:**`iverilog` 不是把 Verilog 编译成机器码,`vvp` 才是真正执行仿真的程序。**
它俩的关系更像 `javac` + `java`,而不是 `gcc` + 直接跑出来的 ELF。

```
hello.v  --[iverilog]-->  hello (vvp 字节码)  --[vvp]-->  Hello, World
 源码                      中间产物                      仿真运行
```

### 2.1 `iverilog -o hello hello.v`

`iverilog` 是驱动程序,内部依次做:

1. **预处理**(`ivlpp`):处理 `` `include ``、`` `define ``、`` `ifdef `` 等宏。
2. **词法 / 语法分析**:把文本解析成语法树,识别 `module`、`initial`、`begin/end`、系统任务 `$display` 等。
3. **elaboration(展开)**:确定顶层模块(这里 `hello` 没有端口,自动成为顶层),建立模块层次、信号表、时间精度。
4. **代码生成**(target = `vvp`):把行为描述翻译成 vvp 虚拟机指令。`initial` 块变成一条**线程**,`$display` 变成一条 `%vpi_call` 指令。
5. **写输出文件**:`-o` 指定产物名;不写 `-o` 时默认输出 `a.out`。

所以 `-o` 后面只是**文件名**,和源码名无关,`-o sim`、`-o build/hello.vvp` 都可以。

### 2.2 `vvp hello`

`vvp` 是事件驱动的仿真内核(虚拟机),它做:

1. **读取并解析** `hello` 里的指令。
2. **加载 `:vpi_module` 列出的动态库**(`system.vpi`、`vhdl_sys.vpi`、数学库等),系统任务 `$display` / `$finish` 的实现就在这些库里。
3. **构建仿真世界**:按 `.scope` 建立模块层次、分配信号存储。Verilog 信号是四值逻辑(`0/1/x/z`),不是 C 的 `int`。
4. **调度线程**:每个 `initial` / `always` 块编译成一条线程,时间 0 时**所有 initial 块同时启动**。这里只有 `T_0` 一条。
5. **执行 `T_0`**:
   - `$display("Hello, World")` → 格式化并打印到 stdout(自带换行)。
   - `$finish` → 通知调度器结束仿真。
6. **退出进程**。

### 2.3 时间轴

```
t=0  ── initial 线程启动 ──> $display 打印 ──> $finish 结束仿真 ──> 进程退出
```

因为没有 `#delay`、没有事件等待,仿真时间一直停在 0,所以瞬间结束。

## 3. 中间产物长什么样

`hello` **不是** ELF 可执行文件,而是 891 字节的纯文本,`cat` 就能看:

```
#! /usr/bin/vvp                        ← shebang,所以 ./hello 也能直接跑
:ivl_version "11.0 (stable)";          ← 编译器版本
:ivl_delay_selection "TYPICAL";        ← 延迟取 typical 值(对应 -T 选项)
:vpi_time_precision + 0;               ← 时间精度 10^0
:vpi_module ".../ivl/system.vpi";      ← 运行时需要加载的 VPI 动态库

S_0x... .scope module, "hello" "hello" 2 1;   ← 模块 hello,定义在 文件#2 第1行
 .timescale 0 0;
    .scope S_0x...;
T_0 ;
    %vpi_call 2 4 "$display", "Hello, World" {0 0 0};   ← 第4行的 $display
    %vpi_call 2 5 "$finish" {0 0 0};                     ← 第5行的 $finish
    %end;
    .thread T_0;                       ← 注册成一条可执行线程

:file_names 3;                         ← 文件编号表:0=N/A, 1=<interactive>, 2=hello.v
```

要点:

- `%vpi_call 2 4` 的 `2` 是**文件编号**(查 `:file_names` 得到 `hello.v`),`4` 是**源码行号**,用于报错和调试定位。
- 系统任务是运行时由 `vvp` 加载 `.vpi` 动态库提供的,不在编译产物里实现。
- 所以产物小、跨平台:它是"指令 + 元数据",真正的机器码在 `vvp` 里。

## 4. 常用命令速查

| 命令 | 作用 |
| --- | --- |
| `iverilog -o <out> a.v b.v` | 编译多个源文件到指定产物 |
| `iverilog a.v` | 不带 `-o`,默认输出 `a.out` |
| `iverilog -s <top> ...` | 手动指定顶层模块(文件里有多个 module 时有用) |
| `iverilog -g2012 ...` | 指定语言标准(如 SystemVerilog-2012) |
| `iverilog -I <dir> -D<MACRO> ...` | 指定 include 目录 / 定义宏 |
| `iverilog -Wall ...` | 打开常用告警 |
| `iverilog -Tmin\|-Ttyp\|-Tmax ...` | 选择延迟模型 |
| `vvp <file>` | 运行仿真 |
| `vvp -v <file>` | 显示加载的 VPI 模块等调试信息 |

## 5. 常见坑

- **改了 `.v` 忘了重新 `iverilog`**:`vvp` 跑的还是旧产物,现象就是"代码改了没生效"。这是最常见的问题。
- **以为 `hello` 是原生程序**:其实第一行是 `#! /usr/bin/vvp`,是内核用 `vvp` 去解释它。
- **`-o` 和源文件名搞混**:`-o` 只是产物名,不参与语法检查。
- **`$display` vs `$write`**:`$display` 自动换行,`$write` 不换行。
- **编译产物不要提交到 git**:`hello`、`a.out`、`*.vcd`、`*.vvp` 都是生成物,建议加进 `.gitignore`。

## 6. 计数器与 testbench

第一个真正“有时序”的例子:带异步复位的计数器,外加一个产生时钟和复位的 testbench。

### 6.1 被测模块 `counter.v`

```verilog
module counter(out, clk, reset);

  parameter WIDTH = 8;

  output [WIDTH-1 : 0] out;
  input              clk, reset;

  reg [WIDTH-1 : 0]   out;
  wire               clk, reset;

  always @(posedge clk or posedge reset)
    if (reset)
      out <= 0;
    else
      out <= out + 1;

endmodule // counter
```

要点:

- `parameter WIDTH = 8`:位宽参数,例化时可以覆盖(如 `counter #(.WIDTH(4)) c1 (...)`)。
- 敏感列表 `posedge clk or posedge reset`:**异步复位**,reset 一拉高立刻清零,不用等时钟。
- `if (reset) ... else ...`:复位优先级最高。
- `out <= 0` 用**非阻塞赋值** `<=`:时序逻辑的标准写法,所有寄存器在同一时刻统一更新。
- `wire clk, reset;` 是冗余的(输入端口默认就是 wire),但语法合法。
- `$finish` 之前 `out` 是 `x`:寄存器未初始化,仿真开始时就是 unknown。

### 6.2 testbench `counter_tb.v`

```verilog
module test;

  /* Make a reset that pulses once. */
  reg reset = 0;
  initial begin
     # 17 reset = 1;
     # 11 reset = 0;
     # 29 reset = 1;
     # 11 reset = 0;
     # 100 $stop;
  end

  /* Make a regular pulsing clock. */
  reg clk = 0;
  always #5 clk = !clk;

  wire [7:0] value;
  counter c1 (value, clk, reset);

  initial
     $monitor("At time %t, value = %h (%0d)",
              $time, value, value);
endmodule // test
```

要点:

- `always #5 clk = !clk;`:每 5 个时间单位翻转一次,周期 10,posedge 出现在 5, 15, 25, ...
- `reg reset = 0;` 在声明处初始化,等价于时间 0 赋初值。
- `counter c1 (value, clk, reset);`:按**位置**例化,端口顺序必须和模块声明一致。
- `$monitor`:只要参数列表里的值有变化就打印一行,整个仿真只需要注册一次。
- `$stop`:暂停仿真并进入 **vvp 交互模式**(不是结束);`$stop` 位置在 t = 17+11+29+11+100 = **168**。

### 6.3 编译运行

```sh
iverilog -Wall -o counter counter.v counter_tb.v
vvp counter
```

因为 `$stop` 会停下来等输入,非交互环境下可以直接喂一个 `finish`:

```sh
printf 'finish\n' | vvp counter
```

实际输出:

```
At time                    0, value = xx (x)
At time                   17, value = 00 (0)
At time                   35, value = 01 (1)
At time                   45, value = 02 (2)
At time                   55, value = 03 (3)
At time                   57, value = 00 (0)
At time                   75, value = 01 (1)
At time                   85, value = 02 (2)
At time                   95, value = 03 (3)
At time                  105, value = 04 (4)
At time                  115, value = 05 (5)
At time                  125, value = 06 (6)
At time                  135, value = 07 (7)
At time                  145, value = 08 (8)
At time                  155, value = 09 (9)
At time                  165, value = 0a (10)
** VVP Stop(0) **
** Flushing output streams.
** Current simulation time is 168 ticks.
> finish
```

### 6.4 逐行读波形

| 时间 | 发生了什么 | value |
| --- | --- | --- |
| 0 | 仿真开始,寄存器未初始化 | `xx` (x) |
| 17 | `reset` 上升沿,异步清零 | `00` |
| 25 | clk 上升沿,但 reset 仍为 1,保持清零 | `00`(无变化,不打印) |
| 28 | reset 撤销,此时还没到时钟沿 | `00` |
| 35 | reset 撤销后的第一个 clk 上升沿 | `01` |
| 45 / 55 | 每个上升沿 +1 | `02` / `03` |
| 57 | reset 再次拉高,计数被打断 | `00` |
| 65 | clk 上升沿,reset 仍为 1 | `00`(不打印) |
| 75 → 165 | 正常计数 | `01` → `0a` |
| 168 | `$stop` 暂停仿真 | `0a` |

两个容易忽略的点:

- `$monitor` **只在值变化时打印**,所以 25、65 这种“时钟来了但值没变”的时刻看不到输出。想看每个时钟沿,应该用 `$display` 放在 `always @(posedge clk)` 里。
- `$stop` 之后还有没有输出,取决于你按什么:输入 `finish` 结束,输入 `continue` 继续跑(此时时钟永远不停,会一直跑到你手动中断)。

### 6.5 逐行注释版

`counter.v`

```verilog
module counter(out, clk, reset);   // Verilog-95 风格:端口只列名字,方向/类型在下面声明

  parameter WIDTH = 8;             // 参数常量,例化时可用 #(.WIDTH(n)) 覆盖

  output [WIDTH-1 : 0] out;        // 方向:输出;位宽 8 位,范围 0~255,溢出回绕
  input              clk, reset;   // 两个 1 位输入,端口默认就是 wire

  reg [WIDTH-1 : 0]   out;         // 补数据类型:always 里被赋值的必须是 reg
  wire               clk, reset;   // 冗余:input 已经是 wire,可以删

  always @(posedge clk or posedge reset)  // 两个上升沿都触发 => 异步复位
    if (reset)                     // 复位优先级最高,拉高立刻清零,不等时钟
      out <= 0;                    // 非阻塞:时间步末统一更新,是寄存器语义
    else
      out <= out + 1;              // 每个时钟上升沿 +1;255 再加就是 0

endmodule // counter
```

`counter_tb.v`

```verilog
module test;                       // testbench 顶层,无端口,只用于仿真,不可综合

  reg reset = 0;                   // 声明时初始化,等价于时间 0 赋初值
  initial begin                    // 激励:时间 0 执行一次
     # 17 reset = 1;               // #N 是"相对当前时间"等 N 个时间单位
     # 11 reset = 0;               // 绝对时间点依次是 17 / 28 / 57 / 68 / 168
     # 29 reset = 1;
     # 11 reset = 0;
     # 100 $stop;                  // 暂停并进入 vvp 交互模式(不是结束!)
  end

  reg clk = 0;
  always #5 clk = !clk;            // 每 5 翻转一次,周期 10;posedge 在 5,15,25...

  wire [7:0] value;                // 观测 DUT 输出的连线
  counter c1 (value, clk, reset);  // 按位置例化:value->out, clk->clk, reset->reset

  initial
     $monitor("At time %t, value = %h (%0d)",   // 值一变化就打印一行
              $time, value, value);             // %t 时间, %h 十六进制, %0d 不补位十进制
endmodule // test
```

### 6.6 它对应的硬件电路

计数器 = **寄存器 + 加法器 + 反馈**。`WIDTH=8` 时就是 8 个 D 触发器加一个 8 位递增器:

```
                    +------------------------+
        +---------->|  8 位递增器 (out + 1)  |-------+
        |           +------------------------+       |
        |                                            | d[7:0]
        |           +------------------------+       |
        |    clk -->|  8 x D 触发器          |<------+
        |  reset -->|  (异步清零 CLR,高有效) |
        |           +------------------------+
        |                     |
        +---- out[7:0] <-----+----> 输出
```

代码和电路的对应关系:

| Verilog | 硬件 |
| --- | --- |
| `parameter WIDTH = 8` | 触发器个数、数据通路宽度 |
| `reg [WIDTH-1:0] out` | 8 个 D 触发器,`Q` 输出就是 `out` |
| `always @(posedge clk ...)` | 触发器时钟端接 `clk` |
| `posedge reset` + `if (reset) out <= 0` | 触发器的**异步清零端 CLR**,高有效 |
| `out <= out + 1` | 组合逻辑:`Q` 反馈到 +1,结果接回 `D` |
| `<=` | 8 个触发器在时钟沿**并行**更新 |
| 255 + 1 → 0 | 8 位截断,最高位的进位被丢弃 |

`out + 1` 展开到门级就是一个**进位链**,每一位是一个半加器(XOR 求和、AND 产生进位),第 0 位的进位固定为 1:

```
c0 = 1
d0 = q0 ^ 1 = ~q0        c1 = q0
d1 = q1 ^ c1             c2 = q1 & c1
d2 = q2 ^ c2             c3 = q2 & c2
...
d7 = q7 ^ c7             c8 = q7 & c7   (c8 丢掉)
```

所以 8 位版本大约是:**8 个 DFF + 1 个反相器 + 7 个 XOR + 7 个 AND**。等价的“门级”写法(和原模块仿真结果完全一致):

```verilog
module counter_gate(clk, reset, q);

  input clk, reset;
  output [7:0] q;

  reg  [7:0] q;
  wire [7:0] d;      // 下一状态
  wire [8:0] c;      // 进位链

  assign c[0] = 1'b1;

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : bit
      assign d[i]   = q[i] ^ c[i];   // 半加和
      assign c[i+1] = q[i] & c[i];   // 半加进位
    end
  endgenerate

  always @(posedge clk or posedge reset)
    if (reset) q <= 8'b0;
    else       q <= d;

endmodule
```

**时序上**,最短时钟周期大约受这条路径限制:

```
Tclk >= t(CLK->Q) + t(递增器) + t(setup)
```

8 位行波进位要串 8 级 AND,位数越多关键路径越长;位宽很大时综合工具会换成超前进位(CLA)或 FPGA 的专用进位链(如 Xilinx 的 CARRY4)。这就是为什么“计数器位宽”会影响能跑的最高频率。

**同步复位的话电路会变**:`reset` 不再接 CLR,而是进 `D` 前面的选择逻辑:

```
d = reset ? 0 : (q + 1)
```

也就是多一个 2 选 1(综合成 LUT 里的与或逻辑,或用触发器的同步复位端)。

落地到具体器件:

- **FPGA**:8 个 LUT(算 `d`) + 进位链 + 8 个 FF;`reset` 走 FF 的异步复位端或 LUT。
- **ASIC**:8 个 DFF 标准单元 + XOR/AND 标准单元;`clk` 和 `reset` 各走一棵缓冲树。
- **testbench 不参与**:`counter_tb.v` 只存在于仿真里,不会变成任何电路。

想亲眼验证:`gtkwave` 已经装好,后面加 `$dumpfile`/`$dumpvars` 就能看 `clk`、`reset`、`value` 的波形;想直接看门级网表,可以装 `yosys` 后执行 `yosys -p 'read_verilog counter.v; synth -top counter; stat'`。

### 6.7 `clk` 到底在干什么

一句话:`clk` 是**全局节拍**,它不携带数据,只决定“什么时候把新值提交进触发器”。

“心跳”这个类比有一半是对的:

- **像心跳的地方**:周期性、全局统一、和数据内容无关。
- **不像心跳的地方**:心脏跳动是“供能”,时钟是“发令”。真正干活的是两个时钟沿之间的组合逻辑(加法器),时钟只负责说到点了、大家一起更新。

在本例中:

```
clk   __|‾‾|__|‾‾|__|‾‾|__
        5  10 15 20 25
        ↑     ↑     ↑
       +1    +1    +1
```

- 只在 `posedge`(0 → 1)时执行 `out <= out + 1`。
- 高电平持续期间**不会**连续加,一个周期只加一次。
- 周期是 10 个时间单位,所以每 10 个时间单位 `out` 加 1。

为什么用“边沿”而不是“电平”:

- 边沿是一个明确的瞬间,所有触发器可以在**同一时刻**采样,步调一致。
- 两个沿之间有完整的一段时间,让加法器的输出稳定下来(setup 时间)。
- 如果用电平,加法器输出一变就可能反过来触发自己,产生竞争和振荡。

testbench 里的时钟:

```verilog
reg clk = 0;
always #5 clk = !clk;   // 周期 10,占空比 50%
```

- 这就是在“扮演”晶振 / PLL 的输出。
- 没有 `` `timescale `` 时,这里的 5 是**仿真时间单位**(抽象 tick),不是 5ns。真实板子上时钟由晶振 + PLL 产生,并且走专用时钟树,不是普通 IO。

`clk` 和 `reset` 的角色对比:

| | `clk` | `reset` |
| --- | --- | --- |
| 作用 | 决定**何时**更新 | 强制一个**初值** |
| 何时有效 | 一直跑 | 通常只在启动/异常时 |
| 本例 | 每 10 个 tick 一个上升沿 | 异步、高有效 |

时钟频率的意义:

- **计数速度 = 时钟频率**(每个上升沿 +1)。
- 频率上限由组合逻辑延迟决定:`Tclk >= t(CLK→Q) + t(加法器) + t(setup)`。
- 所以“这个计数器能跑多快”是时序问题,不是 Verilog 语法问题。

常见误区:

- 以为 `clk = 1` 期间会一直加(实际只在上升沿加一次)。
- 把 `always @(clk)` 当成“电平触发”(它其实是**任何变化**都触发,高低沿都算)。
- 忘记 `` `timescale ``,误以为 `#5` 就是 5ns。
- 把 `clk` 当普通数据信号拿去做组合逻辑(真实设计里应使用专用时钟资源)。

## 7. 下一步计划

- [x] `$monitor` / `$strobe` 与 `$display` 的区别(先知道 `$monitor` 是变化触发)
- [x] 写第一个 testbench:例化被测模块、施加激励
- [ ] `$dumpfile` / `$dumpvars` 生成 `.vcd`,用 `gtkwave` 看波形
- [ ] `always @(posedge clk)` 时序逻辑,`assign` 组合逻辑
- [ ] 自动判断结果(`if (value !== expected) $display("FAIL")`),而不是靠肉眼看输出
- [ ] 阻塞赋值 `=` 与非阻塞赋值 `<=` 的区别
- [ ] `` `timescale `` 与仿真时间单位
- [ ] `$stop` 与 `$finish` 的区别(前者进交互,后者直接结束)
