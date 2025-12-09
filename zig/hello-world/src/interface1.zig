const std = @import("std");
const os = std.os;
// Writer interface
const Writer = struct {
    ptr: *anyopaque,
    writeAllFn: *const fn (ptr: *anyopaque, data: []const u8) anyerror!void,

    fn init(ptr: anytype) Writer {
        const T = @TypeOf(ptr);
        const ptr_info = @typeInfo(T);
        const gen = struct {
            pub fn writeAll(pointer: *anyopaque, data: []const u8) anyerror!void {
                const self: *T = @ptrCast(@alignCast(pointer));
                return ptr_info.pointer.child.writeAll(self, data);
            }
        };
        return .{
            .ptr = ptr,
            .WriteAllFn = gen.writeAll,
        };
    }

    pub fn writeAll(self: Writer, data: []const u8) !void {
        return self.writeAllFn(self.ptr, data);
    }
};

// 这里writeAll不具有通用性
const File = struct {
    fn writeAll(ptr: *anyopaque, data: []const u8) !void {
        const self: *File = @ptrCast(@alignCast(ptr));
        _ = self;
        std.debug.print("xxxx: {s}\n", .{data});
    }

    // return the interface struct
    fn writer(self: *File) Writer {
        return .{
            .ptr = self,
            .writeAllFn = writeAll,
        };
    }
};

const Hello = struct {
    fn writeAll(ptr: *anyopaque, data: []const u8) !void {
        const self: *Hello = @ptrCast(@alignCast(ptr));
        _ = self;
        std.debug.print("hello writer: {s}\n", .{data});
    }

    fn writer(self: *Hello) Writer {
        return .{
            .ptr = self,
            .writeAllFn = writeAll,
        };
    }
};

pub fn main() !void {
    var hello: Hello = .{};
    var file: File = .{};
    var ws: [2]Writer = undefined;
    ws[0] = hello.writer();
    ws[1] = file.writer();
    for (ws) |w| {
        try w.writeAll("look");
    }
}
