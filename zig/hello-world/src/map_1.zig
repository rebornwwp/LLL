const std = @import("std");

pub fn main() !void {
    var m = std.BufMap.init(std.heap.page_allocator);
    defer m.deinit();

    try m.put("h", "hello");
    try m.put("w", "world");

    const v1 = m.get("h") orelse "";

    std.debug.print("count: {d}\n", .{m.count()});
    std.debug.print("h: {s}\n", .{v1});
}
