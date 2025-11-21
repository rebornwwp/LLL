//! By convention, main.zig is where your main function lives in the case that
//! you are building an executable. If you are making a library, the convention
//! is to delete this file and start with root.zig instead.
const std = @import("std");
const print = std.debug.print;
const os = std.os;
const assert = std.debug.assert;
const x = 1234;

pub fn main() !void {

    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.

    var stdout_buffer: [1024]u8 = undefined;
    var stdout_writer = std.fs.File.stdout().writer(&stdout_buffer);
    const stdout = &stdout_writer.interface;
    try stdout.print("Run `zig build test` to run the tests.\n", .{});
    try stdout.flush(); // Don't forget to flush!

    const matrix_4x4 = [4][4]f32{
        [_]f32{ 1.0, 0.0, 0.0, 0.0 },
        [_]f32{ 0.0, 1.0, 0.0, 1.0 },
        [_]f32{ 0.0, 0.0, 1.0, 0.0 },
        [_]f32{ 0.0, 0.0, 0.0, 1.0 },
    };

    for (matrix_4x4, 0..) |arr_val, arr_index| {
        for (arr_val, 0..) |val, index| {
            std.debug.print("元素{}-{}是: {}\n", .{ arr_index, index, val });
        }
    }
    // integers
    var one_plus_one: i32 = 1 + 1;
    print("1 + 1 = {}\n", .{one_plus_one});
    one_plus_one = 10;
    print("1 + 1 = {}\n", .{one_plus_one});

    // floats
    const seven_div_three: f32 = 7.0 / 3.0;
    print("7.0 / 3.0 = {}\n", .{seven_div_three});

    // boolean
    print("{}\n{}\n{}\n", .{
        true and false,
        true or false,
        !true,
    });

    // optional
    var optional_value: ?[]const u8 = null;
    assert(optional_value == null);

    print("\noptional 1\ntype: {}\nvalue: {?s}\n", .{
        @TypeOf(optional_value), optional_value,
    });

    optional_value = "hi";
    assert(optional_value != null);

    print("\noptional 2\ntype: {}\nvalue: {?s}\n", .{
        @TypeOf(optional_value), optional_value,
    });

    // error union
    var number_or_error: anyerror!i32 = error.ArgNotFound;

    print("\nerror union 1\ntype: {}\nvalue: {!}\n", .{
        @TypeOf(number_or_error),
        number_or_error,
    });

    number_or_error = 1234;

    print("\nerror union 2\ntype: {}\nvalue: {!}\n", .{
        @TypeOf(number_or_error), number_or_error,
    });
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // Try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "fuzz example" {
    // Try passing `--fuzz` to `zig build` and see if it manages to fail this test case!
    const input_bytes = std.testing.fuzzInput(.{});
    try std.testing.expect(!std.mem.eql(u8, "canyoufindme", input_bytes));
}
