# Zig Allocator 学习笔记：`gpa` 与 `arena` 的区别与选择

> 整理日期：2026-11-01
> 环境：Zig 0.17.0
> 示例来源：`/home/reborn/workspace/kilo-zig/zig-0.17.0`（kilo 编辑器移植版）

## 1. 从一个真实问题出发

kilo 的 `main` 函数里有这样两行：

```zig
pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;

    const args = try init.minimal.args.toSlice(init.arena.allocator());
    defer init.arena.allocator().free(args);

    editor = try Editor.init(allocator, io);
    // ...
}
```

初看会产生两个疑问：

1. 为什么一处用 `init.gpa`，另一处用 `init.arena.allocator()`？
2. 能不能统一成一个 allocator？

答案的关键在于：**它们的类型相同，但分配策略和生命周期不同。**

---

## 2. 首先，它们是同一种类型

```zig
init.gpa                  // 类型：std.mem.Allocator
init.arena.allocator()    // 返回类型：std.mem.Allocator
```

`Editor` 和 `Row` 里保存的字段也是同一种类型：

```zig
// Editor.zig
allocator: std.mem.Allocator,

// Row.zig
allocator: std.mem.Allocator,
```

`std.mem.Allocator` 本质上是一个「类型擦除 + vtable」的接口：

```zig
pub const Allocator = struct {
    /// 指向具体分配器实例的类型擦除指针
    ptr: *anyopaque,
    vtable: *const VTable,

    pub const VTable = struct {
        alloc: *const fn (...) ?[*]u8,
        resize: *const fn (...) bool,
        remap: *const fn (...) ?[*]u8,
        free: *const fn (...) void,
    };
};
```

所以：

- **类型层面已经统一**：都是 `std.mem.Allocator`；
- **实例层面不同**：`ptr` 和 `vtable` 指向不同的实现。

任何接受 `std.mem.Allocator` 的函数，都可以传入 `gpa`、arena、`page_allocator`、`FixedBufferAllocator` 等，编译器不会阻止。真正需要判断的是：**换掉之后语义是否合理。**

---

## 3. `std.process.Init` 提供了什么

Zig 0.17 的 `std.process.Init` 定义（节选）：

```zig
pub const Init = struct {
    /// Permanent storage for the entire process, cleaned automatically on exit.
    /// Threadsafe.
    arena: *std.heap.ArenaAllocator,

    /// A default-selected general purpose allocator for temporary heap
    /// allocations. Debug mode will set up leak checking if possible.
    /// Threadsafe.
    gpa: Allocator,

    /// An appropriate default Io implementation ...
    io: Io,
    // ...
};
```

官方注释已经给出定位：

| 字段 | 定位 | 生命周期 | 释放方式 |
| --- | --- | --- | --- |
| `init.arena` | 进程级永久存储 | 整个进程 | 进程退出时自动整体释放 |
| `init.gpa` | 通用分配器 | 由代码控制 | 手动 `free` / `deinit`，Debug 下可做泄漏检测 |

这里的 “temporary” 不是指“生命周期短”，而是指**由代码显式管理、可释放**。不要误解成“只能放临时变量”。

---

## 4. kilo 中两个 allocator 的实际分工

### 4.1 `init.gpa`：编辑器的主要堆分配器

`allocator` 被传给 `Editor.init(allocator, io)`，之后贯穿整个运行过程：

```zig
editor = try Editor.init(allocator, io);
defer editor.deinit();
```

具体用途：

| 用途 | 位置 |
| --- | --- |
| 每行的 `chars` / `render` / `hl` 三个 `ArrayList` | `Row.zig` |
| 行数组 `rows` | `Editor.zig` |
| 文件名 `self.filename` | `Editor.zig` |
| 读取文件内容 | `Editor.zig` |
| `rowsToString` 生成的保存缓冲区 | `Editor.zig` |
| 查找时备份的高亮切片 | `Editor.zig` |
| 每帧刷新屏幕的 `ab` 缓冲区 | `Editor.zig` |

这些内存有申请也有释放：

```zig
// Row.deinit
self.chars.deinit(self.allocator);
self.render.deinit(self.allocator);
self.hl.deinit(self.allocator);

// 字符串类数据
self.filename = try self.allocator.dupe(u8, filename);
defer self.allocator.free(old_filename);

// 每帧刷新
var ab: std.ArrayList(u8) = .empty;
defer ab.deinit(self.allocator);
```

因此需要 `gpa` 这种**真正支持 free / realloc 的通用分配器**。Debug 模式下 `init.gpa` 还自带泄漏检测，能发现漏掉的 `free`。

### 4.2 `init.arena.allocator()`：只用于命令行参数

```zig
const args = try init.minimal.args.toSlice(init.arena.allocator());
```

`Args.toSlice()` 需要把操作系统给出的原始 argv 转成 Zig 的切片数组，过程中必须分配内存，所以需要传入 allocator。

选择 arena 的理由：

- 参数在启动时分配一次，之后只读；
- 生命周期约等于整个进程；
- arena 在进程退出时自动整体释放，不需要逐个 `free`；
- 错误路径提前返回也不会泄漏。

---

## 5. 能不能统一成一个 allocator？

可以。至少有三种方案。

### 方案 A：全部使用 `gpa`

```zig
const args = try init.minimal.args.toSlice(init.gpa);
defer init.gpa.free(args);

editor = try Editor.init(init.gpa, io);
```

完全可行，也是最直接的统一方式。代价是参数需要自己 `free`，否则 Debug 模式会报告泄漏。

### 方案 B：全部使用 `arena`

```zig
const arena = init.arena.allocator();

const args = try init.minimal.args.toSlice(arena);
editor = try Editor.init(arena, io);
```

能编译、能运行，但**不建议**用于编辑器这类长期运行、频繁增删的程序。

原因在于 `ArenaAllocator.free` 的实现：

```zig
fn free(ctx: *anyopaque, memory: []u8, alignment: Alignment, ret_addr: usize) void {
    // ...
    const cur_end_index = @atomicLoad(usize, &node.end_index, .monotonic);

    if (buf_ptr + cur_end_index != memory.ptr + memory.len) {
        // Not the most recent allocation; we cannot free it.
        return;
    }
    // 只有释放「最后一次分配」时才能真正回收
}
```

也就是说：

- 释放**最后一次分配**：可以回收；
- 释放**更早的分配**：直接 no-op，内存不会归还。

在 kilo 里，删除中间某一行时：

```zig
fn deleteRow(self: *Self, at: usize) void {
    self.rows.items[at].deinit();   // 释放该行的 3 个 ArrayList
    _ = self.rows.orderedRemove(at);
    // ...
}
```

被删除行的内存不是 arena 的最后一次分配，所以用 arena 时**一个字节也回收不了**。反复增删行、每帧刷新，内存只会增长到进程退出。

结论：arena 适合「只增不减、最后一起释放」的数据，不适合高频 alloc/free 的场景。

### 方案 C：全部使用 `gpa`，但参数不 free

```zig
const args = try init.minimal.args.toSlice(init.gpa);
// 不 free
```

程序能跑，但 Debug 模式下会报告 `args` 泄漏。不推荐。

---

## 6. 当前写法中值得改进的地方

这段代码：

```zig
const args = try init.minimal.args.toSlice(init.arena.allocator());
defer init.arena.allocator().free(args);
```

里的 `defer ... free(args)` 基本是多余的：

1. `args` 来自 arena，arena 会在进程退出时整体清理；
2. arena 的 `free` 只有在释放最后一次分配时才能真正回收；
3. 这里 `args` 之后没有再从 arena 分配，所以它确实能回收，但收益可以忽略。

更清晰的写法：

```zig
const gpa = init.gpa;
const arena = init.arena.allocator();

const args = try init.minimal.args.toSlice(arena);
// 不需要 defer free：arena 随进程退出整体释放

editor = try Editor.init(gpa, io);
defer editor.deinit();
```

好处：

- 变量名 `gpa` / `arena` 直接表达用途；
- 不再重复调用 `init.arena.allocator()`；
- 去掉没有实际意义的 `defer`。

---

## 7. 何时选 `gpa`，何时选 `arena`

| 场景 | 推荐 | 原因 |
| --- | --- | --- |
| 反复 alloc/free、需要 realloc | `gpa` | 真正支持释放和扩容 |
| 启动参数、配置等进程级数据 | `arena` | 一次分配，退出统一释放 |
| 请求级临时数据（如 HTTP handler） | 独立 `ArenaAllocator` + `reset` | 请求结束一次性归还 |
| 固定大小、生命周期明确的临时缓冲 | `FixedBufferAllocator` / 栈 | 无堆分配、零碎片 |
| 性能敏感的短生命周期分配 | `SmpAllocator` / 专用池 | 减少锁竞争和碎片 |

一个简单的判断流程：

```text
需要单独 free 或 realloc 吗？
├── 是 → gpa / 通用分配器
└── 否 → 生命周期是否一致？
        ├── 是 → arena
        └── 否 → 再拆分作用域或换分配器
```

---

## 8. 常见误区

### 误区 1：`arena` 一定更快，所以到处用

arena 分配很快，但 `free` 基本无效。对长期运行的程序，可能导致内存持续增长。arena 的优势是**批量释放**，不是“免费的内存管理”。

### 误区 2：`init.gpa` 只能放临时变量

`gpa` 是通用分配器，任何手动管理生命周期的内存都可以用它，包括编辑器行数据这种长期存在的数据。

### 误区 3：Zig 的 allocator 是不同类型

所有标准 allocator 最终都通过 `std.mem.Allocator` 暴露，是同一个类型、不同实现。API 统一，策略不统一。

### 误区 4：`free` 在 arena 上完全没意义

不是完全没意义：释放最后一次分配时可以回收。但依赖这个行为会让代码对分配顺序非常敏感，不应作为设计基础。

---

## 9. 总结

- `gpa` 和 `arena` **类型相同**，都是 `std.mem.Allocator`；
- 区别在**分配策略、生命周期和释放语义**；
- `args` 是进程级一次性数据，适合 arena；
- 编辑器行数据、渲染缓冲需要频繁 alloc/free，适合 gpa；
- 统一成一个 allocator 是可行的，但用 arena 承担编辑器的高频分配会导致内存只增不减；
- 当前代码可以简化：去掉 arena 上多余的 `defer free`，用 `gpa` / `arena` 两个变量名表达意图。

一句话记忆：

> **arena 管“最后一起释放”，gpa 管“随时申请随时还”。**

---

## 参考

- Zig 0.17.0 源码：`std/process.zig`（`Init` 定义）
- Zig 0.17.0 源码：`std/mem/Allocator.zig`（Allocator / VTable）
- Zig 0.17.0 源码：`std/heap/ArenaAllocator.zig`（`free` 实现）
- 示例项目：`/home/reborn/workspace/kilo-zig/zig-0.17.0`
- 相关迁移说明：`/home/reborn/workspace/kilo-zig/zig-0.17.0/README.md`
