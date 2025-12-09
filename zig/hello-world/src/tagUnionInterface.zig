const std = @import("std");

const Writer = union(enum) {
    file: File,

    fn writeAll(self: Writer, data: []const u8) !void {
        switch (self) {
            .file => |file| return file.writeAll(data),
        }
    }
};

const File = struct {
    fn writeAll(self: File, data: []const u8) !void {
        _ = self;
        std.debug.print("hello {s}\n", .{data});
    }
};

pub fn main() !void {
    const file = File{};
    const writer = Writer{ .file = file };
    try writer.writeAll("hi");
}
