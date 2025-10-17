const Lexer = @This();

const std = @import("std");
const token = @import("./token.zig");
const newToken = token.newToken;

allocator: std.mem.Allocator,
input: []const u8,
position: usize,
readPosition: usize,
ch: u8,
tokenMap: token.KeyWords,

fn isLetter(c: u8) bool {
    return ('a' <= c and c <= 'z') || ('A' <= c and c <= 'Z') || c == '_';
}

fn isDigit(c: u8) bool {
    return '0' <= c and c <= '9';
}

pub fn init(input: []const u8) Lexer {
    const l = Lexer{ .input = input };
    l.readChar();
    return l;
}

pub fn nextToken(l: *Lexer) token.Token {
    l.skipWhiteSpace();
    switch (l.ch) {
        '+' => return newToken(token.PLUS, "+"),
        '-' => return newToken(token.MINUS, "-"),
        '*' => return newToken(token.ASTERISK, "*"),
        '/' => return newToken(token.SLASH, "/"),
        '=' => {
            if (l.peakChar() == '=') {
                l.readChar();
                return newToken(token.EQ, "==");
            }
            return newToken(token.ASSIGN, "=");
        },
        '!' => {
            if (l.peakChar() == '=') {
                l.readChar();
                return newToken(token.NOTEQ, "!=");
            }
            return newToken(token.BANG, "!");
        },
        '<' => return newToken(token.LT, "<"),
        '>' => return newToken(token.GT, ">"),
        ',' => return newToken(token.COMMA, ","),
        ';' => return newToken(token.SEMICOLON, ";"),
        '(' => return newToken(token.LPAREN, "("),
        ')' => return newToken(token.RPAREN, ")"),
        '{' => return newToken(token.LBRACE, "{"),
        '}' => return newToken(token.RBRACE, "}"),
        '"' => return newToken(token.STRING, l.readString()),
        '[' => return newToken(token.LBRACKET, "["),
        ']' => return newToken(token.RBRACKET, "]"),
        ':' => return newToken(token.COLON, ":"),
        else => {
            if (isLetter(l.ch)) {
                const ident = l.readIdentifier();
                const tkType = l.tokenMap.LookupKey(ident);
                return newToken(tkType, ident);
            } else if (isDigit(l.ch)) {
                const num = l.readNumber();
                return newToken(token.INT, num);
            }

            return newToken(token.ILLEGAL, "");
        },
    }
    l.readChar();
}

pub fn readChar(l: *Lexer) void {
    l.ch = if (l.readPosition >= l.input.len)
        0
    else
        l.input[l.readPosition];
    l.position = l.readPosition;
    l.readPosition += 1;
}

pub fn peakChar(l: *Lexer) u8 {
    if (l.readPosition >= l.input.len) {
        return 0;
    }
    return l.input[l.readPosition];
}

pub fn readIdentifier(l: *Lexer) []const u8 {
    const position = l.position;
    while (isLetter(l.ch)) {
        l.readChar();
    }
    return l.input[position..l.position];
}

pub fn readNumber(l: *Lexer) []const u8 {
    const position = l.position;
    while (isDigit(l.ch)) {
        l.readChar();
    }
    return l.input[position..l.position];
}
pub fn readString(l: *Lexer) []const u8 {
    const position = l.position + 1;
    while (true) {
        l.readChar();
        if (l.ch == '"' or l.ch == 0) {
            break;
        }
    }
    return l.input[position..l.position];
}

pub fn skipWhiteSpace(l: *Lexer) void {
    while (l.ch == ' ' or l.ch == '\n' or l.ch == '\t' or l.ch == '\r') {
        l.readChar();
    }
}
