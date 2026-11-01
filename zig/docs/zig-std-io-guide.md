# Zig 0.17 `std.Io` 学习笔记：整体逻辑与使用指南

> 整理日期：2026-11-02
> 环境：Zig 0.17.0
> 相关笔记：[`gpa` 与 `arena` 的区别](./zig-allocators-gpa-vs-arena.md)
> 示例来源：`/home/reborn/workspace/kilo-zig/zig-0.17.0`

## 1. 一句话理解

`std.Io` 是 Zig 0.17 的 **I/O 与并发运行时接口**，地位类似 `std.mem.Allocator`：

- `Allocator` 抽象“内存怎么分配”；
- `Io` 抽象“文件、网络、进程、时间、并发怎么做”。

业务代码只依赖 `Io` 这个接口，具体是**阻塞线程池**、**io_uring** 还是**事件循环**，由运行时决定。

---

## 2. 分层结构

```text
你的代码
   │
   ├── File / Dir / net / process / Terminal   ← 资源句柄 + 操作
   │
   ├── Reader / Writer                          ← 缓冲 / 格式化接口
   │
   ├── Io { userdata, vtable }                  ← 统一接口
   │        │
   │        ├── Io.Threaded   （线程池 + 阻塞 syscall）
   │        ├── Io.Uring      （Linux io_uring）
   │        ├── Io.Kqueue     （BSD/macOS）
   │        └── Io.Dispatch   （macOS GCD）
   │
   └── async / concurrent / Future / Group / Select / Batch  ← 并发模型
```

核心定义：

```zig
pub const Io = struct {
    userdata: ?*anyopaque,
    vtable: *const VTable,
};
```

和 `Allocator` 一样，是**类型擦除 + vtable**。所有平台相关实现藏在 vtable 后面。

调用链大致是：

```text
dir.readFileAlloc(io, path, gpa, .unlimited)
    → file.reader(io, &buf)
    → reader.allocRemaining(gpa, limit)
    → io.vtable.operate(.{ .file_read_streaming = ... })
    → 具体实现里的 read/pread/io_uring 提交
```

所以写一次代码，换 `Io` 实现就能改变底层策略。

---

## 3. `init.io` 是从哪来的

使用 0.17 的 “juicy main”：

```zig
pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const gpa = init.gpa;
    const arena = init.arena.allocator();
}
```

`std/start.zig` 在调用 `main` 前会自动构造：

- `init.gpa`：Debug/ReleaseSafe 下是 `SafeAllocator`，链接 libc 的 Release 下是 `c_allocator`，否则是 `smp_allocator`；
- `init.arena`：由 `page_allocator` 支撑的进程级 arena，退出时自动 `deinit`；
- `init.io`：默认是 **`std.Io.Threaded`** 实例，即线程池 + 阻塞 I/O。

如果不想用 `std.process.Init`，可以手动创建：

```zig
pub fn main() !void {
    var threaded: std.Io.Threaded = .init(std.heap.page_allocator, .{});
    defer threaded.deinit();

    const io = threaded.io();
    try std.Io.File.stdout().writeStreamingAll(io, "manual threaded io\n");
}
```

> 传给 `Threaded.init` 的 allocator 必须是线程安全的，因为它用来分配 Future、线程等。

Linux 上也可以显式用 io_uring：

```zig
var evented: std.Io.Evented = undefined;   // Linux 上即 std.Io.Uring
try evented.init(gpa, .{});
defer evented.deinit();
const io = evented.io();
```

一般业务代码不需要关心这个，直接用 `init.io` 即可。

---

## 4. 最重要的三条使用原则

### 原则一：`io` 显式传递，不藏全局变量

```zig
const file = try std.Io.Dir.cwd().openFile(io, "a.txt", .{});
defer file.close(io);
```

`io` 像 allocator 一样显式传给每个操作。好处：

- 可测试：可以注入假 `Io`；
- 可选择实现：线程池 / io_uring 随意切换；
- 取消、超时、并发都有明确上下文。

### 原则二：句柄只表示资源，操作都带 `io`

```text
File:  openFile(io, ...) / read(io, ...) / close(io)
Dir:   openDir(io, ...)  / createFile(io, ...) / close(io)
net:   connect(io, ...)  / read(io, ...) / close(io)
```

句柄本身不持有运行时，所以同一个文件可以被不同 `Io` 实现操作（虽然通常不会这么干）。

### 原则三：Reader / Writer 的缓冲区由调用者提供

Zig 0.17 的 `std.Io.Reader` / `std.Io.Writer` 是**接口**，内部不偷偷分配内存：

```zig
var buf: [4096]u8 = undefined;
var fw = file.writer(io, &buf);
const w = &fw.interface;
try w.print("hello {d}\n", .{42});
try w.flush();   // 必须 flush，否则数据可能还在缓冲区
```

需要动态增长时用 `std.Io.Writer.Allocating`。

---

## 5. 文件 I/O 常用套路

### 5.1 一次读整个文件

```zig
const content = try std.Io.Dir.cwd().readFileAlloc(
    io,
    "a.txt",
    gpa,
    .unlimited,          // 或 .limited(1024 * 1024)
);
defer gpa.free(content);
```

### 5.2 一次写整个文件

```zig
try std.Io.Dir.cwd().writeFile(io, .{
    .sub_path = "out.txt",
    .data = "hello\n",
});
```

### 5.3 打开文件 + 缓冲写入

```zig
const file = try std.Io.Dir.cwd().createFile(io, "out.txt", .{ .truncate = true });
defer file.close(io);

var buf: [4096]u8 = undefined;
var fw = file.writer(io, &buf);       // 普通文件用 positional
try fw.interface.writeAll("hello\n");
try fw.interface.flush();
```

对 stdout、管道、socket 这类不可 seek 的目标，用 streaming 版本：

```zig
var fw = std.Io.File.stdout().writerStreaming(io, &buf);
```

### 5.4 逐行读

```zig
const file = try std.Io.Dir.cwd().openFile(io, "a.txt", .{});
defer file.close(io);

var buf: [256]u8 = undefined;
var fr = file.reader(io, &buf);       // 普通文件
const r = &fr.interface;

while (try r.takeDelimiter('\n')) |line| {
    // line 不包含 '\n'
    std.debug.print("line: {s}\n", .{line});
}
```

stdin / socket 用 `readerStreaming`。

### 5.5 不要忘记 flush

```zig
var fw = std.Io.File.stdout().writerStreaming(io, &buf);
const w = &fw.interface;

try w.print("hello {s}\n", .{"world"});
try w.flush();   // 少了这句，输出可能丢失
```

---

## 6. 网络 I/O

```zig
var address = try std.Io.net.IpAddress.parse("127.0.0.1", 8080);
const stream = try address.connect(io, .{ .mode = .stream });
defer stream.close(io);

var write_buf: [1024]u8 = undefined;
var sw = stream.writer(io, &write_buf);
try sw.interface.writeAll("GET / HTTP/1.1\r\n\r\n");
try sw.interface.flush();

var read_buf: [4096]u8 = undefined;
var sr = stream.reader(io, &read_buf);
const n = try sr.interface.readSliceShort(&read_buf);
```

TCP server 用 `address.listen(io, .{})` → `server.accept(io)`，模式和文件类似：**拿句柄、传 io、用 Reader/Writer 缓冲**。

---

## 7. 并发模型：`async` vs `concurrent`

### 7.1 `io.async`

```zig
const Add = struct {
    fn add(a: u32, b: u32) u32 {
        return a + b;
    }
};

var future = io.async(Add.add, .{ 20, 22 });
const sum = future.await(io);   // 42
```

特点：

- 函数**可能立即执行完**，也可能被交给线程池/事件循环；
- 兼容性最好，允许单线程实现；
- 返回 `Future(T)`，用 `await(io)` 取结果，用 `cancel(io)` 请求取消。

### 7.2 `io.concurrent`

```zig
var future = try io.concurrent(Add.add, .{ 1, 2 });
const sum = future.await(io);
```

要求更强的并发保证，因此可能返回：

```zig
error.ConcurrencyUnavailable
```

规则：

- 需要“确实在另一个执行单元里跑”时用 `concurrent`；
- 只是“稍后取结果”用 `async` 更可移植。

### 7.3 `Group`：批量启动、统一等待

```zig
const Job = struct {
    fn run(a: u32) std.Io.Cancelable!void {
        _ = a;
    }
};

var group: std.Io.Group = .init;
group.async(io, Job.run, .{1});
group.async(io, Job.run, .{2});
try group.await(io);
```

`Group` 适合“一组任务一起等”或“一起取消”，不关心单个返回值。

### 7.4 时间

```zig
try io.sleep(.fromMilliseconds(10), .awake);
```

`Clock` 常用值：

- `.awake`：单调时钟，不包含系统休眠时间；
- `.boot`：包含系统休眠时间；
- `.real`：墙上时钟；
- `.cpu_process` / `.cpu_thread`：CPU 时间。

超时用 `Io.Timeout`：

```zig
try io.operateTimeout(operation, .{ .duration = .fromMilliseconds(100) });
```

### 7.5 取消

很多 Io 函数返回 `Cancelable!T`，即可能返回：

```zig
error.Canceled
```

规则：

- `Future.cancel(io)` 只是**请求**取消，任务会在下一个取消点收到 `error.Canceled`；
- 不要吞掉 `error.Canceled`，否则取消信号会丢失；
- 需要短暂禁止取消时用 `io.swapCancelProtection(...)`；
- `defer` 仍然会正常执行，资源清理不受影响。

---

## 8. 错误处理的隐藏点

`File.Reader` / `File.Writer` 把底层错误包装成统一接口：

```zig
var fr = file.reader(io, &buf);
const r = &fr.interface;

const data = r.takeDelimiter('\n') catch |err| switch (err) {
    error.ReadFailed => return fr.err.?,   // 真实错误在这里
    else => return err,
};
```

同样，`File.Writer` 的 `err` 字段保存真实写错误。看到 `ReadFailed` / `WriteFailed` 时，先检查适配器的 `.err`。

---

## 9. 从旧 API 迁移的对照表

| 旧写法（0.15/0.16 及以前） | 0.17 写法 |
| --- | --- |
| `std.io.getStdOut().writer()` | `std.Io.File.stdout().writerStreaming(io, &buf)` |
| `std.io.getStdErr().writer()` | `std.Io.File.stderr().writerStreaming(io, &buf)` |
| `std.fs.cwd()` | `std.Io.Dir.cwd()` |
| `std.fs.File` | `std.Io.File` |
| `file.reader()` | `file.reader(io, &buf)` |
| `file.writer()` | `file.writer(io, &buf)` |
| `dir.readFileAlloc(alloc, path, max)` | `dir.readFileAlloc(io, path, alloc, limit)` |
| `std.Thread.sleep(ns)` | `io.sleep(.fromNanoseconds(ns), .awake)` |
| `std.posix.read/write` | 用 `File` / `net.Stream`，或低层 `io.operate(...)` |
| `std.io.Writer` 泛型 writer | `std.Io.Writer` 接口 + 调用者提供 buffer |

注意：Zig 0.17 中 `std.io` 已不存在，`std.fs` 只剩 `std.fs.path`。文件、目录、网络全部迁到 `std.Io.*`。

---

## 10. 最小模板

```zig
const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const gpa = init.gpa;

    // 读
    const data = try std.Io.Dir.cwd().readFileAlloc(io, "in.txt", gpa, .unlimited);
    defer gpa.free(data);

    // 写
    try std.Io.Dir.cwd().writeFile(io, .{
        .sub_path = "out.txt",
        .data = data,
    });

    // 输出
    try std.Io.File.stdout().writeStreamingAll(io, "done\n");
}
```

---

## 11. 总结

Zig 0.17 的 `Io` 逻辑可以概括为：

1. **`Io` 是运行时接口**，和 `Allocator` 一样通过 vtable 抽象；
2. **所有资源操作显式传 `io`**，不依赖全局状态；
3. **`File` / `Dir` / `net` 是句柄 + 操作**，底层通过 `io.operate` 落到具体实现；
4. **`Reader` / `Writer` 负责缓冲和格式化**，缓冲区由调用者提供；
5. **并发统一成 `Future` / `Group` / `Batch`**，用 `async` 或 `concurrent` 启动；
6. **取消是一等公民**，`error.Canceled` 必须正确传播；
7. **旧 `std.fs` / `std.io` 已移除**，新代码直接用 `std.Io.*`。

实际写代码时记住一句话：

> **拿到 `io`，选好句柄（File/Dir/Stream），需要缓冲就配 Reader/Writer，需要并行就 async/concurrent，最后别忘了 flush。**

---

## 参考

- Zig 0.17.0 源码：`std/Io.zig`、`std/Io/File.zig`、`std/Io/Dir.zig`
- Zig 0.17.0 源码：`std/Io/Reader.zig`、`std/Io/Writer.zig`
- Zig 0.17.0 源码：`std/Io/Threaded.zig`、`std/Io/Uring.zig`
- Zig 0.17.0 源码：`std/start.zig`（`std.process.Init` 的构造过程）
- 示例项目：`/home/reborn/workspace/kilo-zig/zig-0.17.0`
