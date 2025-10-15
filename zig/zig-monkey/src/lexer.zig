const Lexer = @This();

const std = @import("std");
const token = @import("./token.zig");

allocator: std.mem.Allocator,
input: []const u8,
position: usize,
readPosition: usize,
ch: u8,

fn isLetter(c: u8) bool {
    return ('a' <= c and c <= 'z') || ('A' <= c and c <= 'Z') || c == '_';
}

fn isDigit(c: u8) bool {
    return '0' <= c and c <= '9';
}

pub fn init(input: []const u8) Lexer {
    return Lexer{ .input = input };
}

pub fn nextToken(l: *Lexer) token.Token {
    _ = l;
}

pub fn readChar(l: *Lexer) void {
    l.ch = if (l.readPosition >= l.input.len)
        0
    else
        l.input[l.readPosition];
    l.position = l.readPosition;
    l.readPosition += 1;
}

pub fn peakChar(l: *Lexer) void {
    _ = l;
}

pub fn readIdentifier(l: *Lexer) token.Token {
    _ = l;
}

pub fn readNumber(l: *Lexer) token.Token {
    _ = l;
}
pub fn readString(l: *Lexer) token.Token {
    _ = l;
}

pub fn skipWhiteSpace(l: *Lexer) void {
    while (l.ch == ' ' or l.ch == '\n' or l.ch == '\t' or l.ch == '\r') {
        l.readChar();
    }
}
