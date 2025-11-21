const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    // const allocater = gpa.allocator();

    const file = try fs.cwd().openFile("tests/zen.txt", .{});
    defer file.close();

    var buffer: [1024]u8 = undefined;
    var file_reader = file.reader(&buffer);
    var line_no: usize = 0;

    while (file_reader.interface.takeDelimiterInclusive('\n')) |line| {
        print("XXX: {s}", .{line});
        line_no += 1;
    } else |err| switch (err) {
        error.EndOfStream => {
            print("end of stream\n", .{});
        },
        else => {},
    }
    print("Total lines: {d}\n", .{line_no});
}
