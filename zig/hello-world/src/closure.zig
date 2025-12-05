const std = @import("std");
const Allocator = std.mem.Allocator;

const Job = struct {
    id: usize,

    pub fn run(self: *Job, message: anytype) void {
        std.debug.print("run job {d} message is: {any}\n", .{ self.id, message });
    }
};

const JobQueue = struct {
    len: usize = 0,
    pending: [5]Runable = undefined,

    pub fn add(self: *JobQueue, allocator: Allocator, job: *Job, message: anytype) !void {
        const Closure = struct {
            job: *Job,
            allocator: Allocator,
            message: @TypeOf(message),

            fn run(ptr: *anyopaque) void {
                var c: *@This() = @ptrCast(@alignCast(ptr));
                defer c.allocator.destroy(c);
                c.job.run(c.message);
            }
        };
        const closure = try allocator.create(Closure);
        closure.* = .{ .allocator = allocator, .job = job, .message = message };

        self.pending[self.len] = .{
            .ptr = closure,
            .runFn = Closure.run,
        };
        self.len += 1;
    }

    pub fn runOne(self: *JobQueue) void {
        if (self.len <= 0) return;
        const len = self.len - 1;
        const data = self.pending[len];
        data.runFn(data.ptr);
        self.len = len;
    }
};

const Runable = struct {
    ptr: *anyopaque,
    runFn: *const fn (ptr: *anyopaque) void,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.detectLeaks();

    var queue = JobQueue{};

    var job = Job{ .id = 1 };
    try queue.add(allocator, &job, "hello");
    var job2 = Job{ .id = 2 };
    try queue.add(allocator, &job2, "hello2");
    try queue.add(allocator, &job, "hello");
    // without the @as, 123 is a comptime_int, which will not work
    try queue.add(allocator, &job, @as(u32, 123));

    queue.runOne();
    queue.runOne();
    queue.runOne();
    queue.runOne();
}
