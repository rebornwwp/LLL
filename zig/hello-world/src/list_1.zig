const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var gpa1 = std.heap.ArenaAllocator.init(gpa.allocator());
    const allocator = gpa1.allocator();
    // const allocator = gpa.allocator();

    var buffer: [2048]i32 = undefined;
    var l = std.ArrayList(i32).initBuffer(&buffer);
    defer l.deinit(allocator);

    try l.append(allocator, 10);
    try l.append(allocator, 11);
    try l.append(allocator, 12);

    try l.appendSlice(allocator, &[_]i32{ 13, 14, 15 });
    const v1 = try l.addOne(allocator);
    v1.* = 16;

    try l.insert(allocator, 0, 9);

    for (l.items, 0..) |item, index| {
        std.debug.print("index: {d}, item: {d}\n", .{ index, item });
    }

    var cloned = try l.clone(allocator);
    defer cloned.deinit(allocator);
    for (cloned.items, 0..) |item, index| {
        std.debug.print("cloned index: {d}, item: {d}\n", .{ index, item });
    }
    std.debug.print("Hello, World!\n", .{});
}
