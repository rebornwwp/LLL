const std = @import("std");
const Allocator = std.mem.Allocator;

const TokenType = enum([]u8) {
    ILLEGAL = "ILLEGAL",
    EOF = "EOF",

    // Identifiers + literals
    IDENT = "IDENT", // add, foobar, x, y, ...
    INT = "INT",

    // Operators
    ASSIGN = "=",
    PLUS = "+",
    MINUS = "-",
    BANG = "!",
    ASTERISK = "*",
    SLASH = "/",

    LT = "<",
    GT = ">",
    EQ = "==",
    NOTEQ = "!=",

    // Delimiters
    COMMA = ",",
    SEMICOLON = ";",
    LPAREN = "(",
    RPAREN = ")",
    LBRACE = "{",
    RBRACE = "}",

    // Keywords
    // 1343456
    FUNCTION = "FUNCTION",
    LET = "LET",
    TRUE = "TRUE",
    FALSE = "FALSE",
    IF = "IF",
    ELSE = "ELSE",
    RETURN = "RETURN",

    // data type
    STRING = "STRING",
    LBRACKET = "[",
    RBRACKET = "]",
    COLON = ":",
};

const Token = struct {
    tokenTp: TokenType,
    literal: []const u8,
};

pub fn newToken(tk: TokenType, l: []const u8) Token {
    return .{
        .tokenTp = tk,
        .literal = l,
    };
}

const KeyWords = struct {
    allocator: Allocator,
    kws: std.AutoHashMap([]const u8, TokenType),

    const Self = @This();
    pub fn init(allocator: Allocator) *Self {
        var self = try allocator.create(Self);
        self.allocator = allocator;
        self.kws = std.AutoArrayHashMap([]const u8, TokenType).init(allocator);
        self.kws.put("let", TokenType.LET);
        self.kws.put("fn", TokenType.FUNCTION);
        self.kws.put("true", TokenType.TRUE);
        self.kws.put("false", TokenType.FALSE);
        self.kws.put("if", TokenType.IF);
        self.kws.put("else", TokenType.ELSE);
        self.kws.put("return", TokenType.RETURN);
        return self;
    }

    pub fn deinit(self: *Self) void {
        self.kws.deinit();
        self.allocator.destroy(self);
    }

    pub fn LookupKey(self: *Self, ident: []const u8) TokenType {
        if (self.kws.get(ident)) |tkTp| {
            return tkTp;
        }
        return TokenType.IDENT;
    }
};
