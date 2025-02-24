const std = @import("std");
const print = std.debug.print;
const Child = std.process.Child;
const ArrayList = std.ArrayList;

pub fn main() !void {
    print("number of logical cores is {}\n", .{try std.Thread.getCpuCount()});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const argv = [_][]const u8{
        "echo",
        "-n",
        "hello",
        "world",
    };

    var child = Child.init(&argv, allocator);
    child.stdout_behavior = .Pipe;
    child.stderr_behavior = .Pipe;
    var stdout = ArrayList(u8).init(allocator);
    var stderr = ArrayList(u8).init(allocator);
    defer {
        stdout.deinit();
        stderr.deinit();
    }

    try child.spawn();
    try child.collectOutput(&stdout, &stderr, 1024);
    const term = try child.wait();

    try std.testing.expectEqual(term.Exited, 0);
    try std.testing.expectEqualStrings("hello world", stdout.items);
    try std.testing.expectEqualStrings("", stderr.items);
}
