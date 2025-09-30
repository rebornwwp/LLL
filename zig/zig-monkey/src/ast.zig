const std = @import("std");
const token = @import("./token.zig");

const Expression = union(enum) {
    const Self = @This();
};

const Statement = union(enum) {};

const Identifier = struct {
    const Self = @This();

    tk: token.Token,
    value: []const u8,

    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }

    pub fn string(self: Self, stream: anytype) !void {
        try stream.print(self.value);
    }
};

const LetStatement = struct {
    tk: token.Token,
    name: Identifier,
    value: ?Expression,

    const Self = @This();
    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }
    pub fn string(self: Self, stream: anytype) !void {
        const let = self.tk.literal;
        const name = self.name.value;
        try stream.print("{s}", let);
        try stream.print("{s} = ", name);
        if (self.value) |value| {
            try value.print(stream);
        }
    }
};
