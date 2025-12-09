const std = @import("std");
const os = std.os;
// Writer interface
const Writer = struct {
    ptr: *anyopaque,
    writeAllFn: *const fn (ptr: *anyopaque, data: []const u8) anyerror!void,

    // 这里实现返回interface的作用
    fn init(ptr: anytype) Writer {
        const T = @TypeOf(ptr);
        const ptr_info = @typeInfo(T);
        const gen = struct {
            pub fn writeAll(pointer: *anyopaque, data: []const u8) anyerror!void {
                const self: T = @ptrCast(@alignCast(pointer));

                // 下面两行代码是可以替代, 但是使用call更好,可以针对函数进行inline
                // return ptr_info.pointer.child.writeAll(self, data);
                return @call(.always_inline, ptr_info.pointer.child.writeAll, .{ self, data });
            }
        };
        return .{
            .ptr = ptr,
            .writeAllFn = gen.writeAll,
        };
    }

    pub fn writeAll(self: Writer, data: []const u8) !void {
        return self.writeAllFn(self.ptr, data);
    }
};

// 这里write all函数正常写
const File = struct {
    fn writeAll(self: *File, data: []const u8) !void {
        _ = self;
        std.debug.print("xxxx: {s}\n", .{data});
    }

    // return the interface struct
    fn writer(self: *File) Writer {
        return Writer.init(self);
    }
};

const Hello = struct {
    fn writeAll(self: *Hello, data: []const u8) !void {
        _ = self;
        std.debug.print("hello writer: {s}\n", .{data});
    }

    fn writer(self: *Hello) Writer {
        return Writer.init(self);
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
