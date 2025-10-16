const std = @import("std");

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
