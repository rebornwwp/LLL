const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

const filename = "/tmp/zig.txt";

pub fn main() !void {
    if (.windows == @import("builtin").os.tag) {
        print("MMap is not supported in windows\n", .{});
        return;
    }
    const file = try fs.cwd().createFile(filename, .{
        .read = true,
        .truncate = true,
        .exclusive = false,
    });
    defer file.close();
    const content_to_write = "hello zig cookbook";
    try file.setEndPos(content_to_write.len);
    const md = try file.metadata();
    try std.testing.expectEqual(md.size(), content_to_write.len);
    const ptr = try std.posix.mmap(
        null,
        content_to_write.len,
        std.posix.PROT.READ | std.posix.PROT.WRITE,
        .{ .TYPE = .SHARED },
        file.handle,
        0,
    );
    defer std.posix.munmap(ptr);
    std.mem.copyForwards(u8, ptr, content_to_write);
    try std.testing.expectEqualStrings(content_to_write, ptr);
    for (0..content_to_write.len) |i| {
        print("index: {d}, {c}\n", .{ i, ptr[i] });
    }
}
