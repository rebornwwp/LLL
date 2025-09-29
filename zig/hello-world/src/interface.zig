const std = @import("std");

const SaveInterface = struct {
    obj_ptr: *anyopaque,
    func_ptr: *const fn (*anyopaque) void,
    input_func_ptr: *const fn (*anyopaque, x: u32) u32,

    const Self = @This();

    fn save(self: Self) void {
        self.func_ptr(self.obj_ptr);
    }

    fn add(self: Self, x: u32) u32 {
        return self.input_func_ptr(self.obj_ptr, x);
    }
};

const MyObject = struct {
    // probably a lot of data members...
    // ...

    // our save function takes in an anyopaque pointer
    // and casts it back to our MyObject type
    pub fn saveMyObject(ptr: *anyopaque) void {
        const self: *MyObject = @ptrCast(@alignCast(ptr));
        std.debug.print("save xxx: {any}\n", .{self});

        // implementation of our save function...
    }

    pub fn add(ptr: *anyopaque, x: u32) u32 {
        _ = ptr;
        return x + 1;
    }

    pub fn saveable(self: *MyObject) SaveInterface {
        return SaveInterface{
            // our self pointer
            .obj_ptr = self,
            // pointer to our save function
            .func_ptr = saveMyObject,
            .input_func_ptr = add,
        };
    }
};

pub fn doStuffAndSave(obj: SaveInterface) void {
    obj.save();
    const x = obj.add(100);
    std.debug.print("xxxx: {d}", .{x});
}

test "hell" {
    var obj: MyObject = .{};
    doStuffAndSave(obj.saveable());
}
