const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    const allocater = gpa.allocator();

    const file = try fs.cwd().openFile("tests/zen.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const reader = buf_reader.reader();
    var line = std.ArrayList(u8).init(allocater);
    defer line.deinit();

    const writer = line.writer();
    var line_no: usize = 0;
    while (reader.streamUntilDelimiter(writer, '\n', null)) {
        defer line.clearRetainingCapacity();
        line_no += 1;
    } else |err| switch (err) {
        error.EndOfStream => {
            if (line.items.len > 0) {
                line_no += 1;
                print("{d}--{s}\n", .{ line_no, line.items });
            }
        },
        else => return err,
    }
    print("Total lines: {d}\n", .{line_no});
}
