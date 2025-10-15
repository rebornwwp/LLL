const Lexer = @This();

const std = @import("std");
const token = @import("./token.zig");

allocator: std.mem.Allocator,
input: []const u8,
position: usize,
readPosition: usize,
ch: u8,

pub fn init(input: []const u8) Lexer {
    return Lexer{ .input = input };
}

pub fn nextToken(l: *Lexer) token.Token {
    _ = l;
}
