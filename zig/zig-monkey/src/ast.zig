const std = @import("std");
const token = @import("./token.zig");

const Expression = union(enum) {
    identifier: Identifier,
    integerLiteral: IntegerLiteral,
    bol: Boolean,
    prefixExpr: PrefixExpression,
    infixExpr: InfixExpression,
    ifExpr: IfExpression,
    funcExpr: FunctionLiteral,
    callExpr: CallExpression,
    strExpr: StringLiteral,
    arrayExpr: ArrayLiteral,
    idxExpr: IndexExpression,
    hashExpr: HashLiteral,

    const Self = @This();
    pub fn tokenLiteral(self: Self) ?[]const u8 {
        if (self.statements.len > 0) {
            return self.statements[0].tokenLiteral();
        }
        return null;
    }

    pub fn string(self: Self, stream: anytype) !void {
        for (self.statements) |st| {
            try stream.print(st.string());
        }
    }
};

const Statement = union(enum) {
    let: LetStatement,
    rturn: ReturnStatement,
    expr: ExpressionStatement,
    bkState: BlockStatement,

    const Self = @This();
};

const Program = struct {
    statements: []Statement,

    const Self = @This();
    pub fn tokenLiteral(self: Self) ?[]const u8 {
        if (self.statements.len > 0) {
            return self.statements[0].tokenLiteral();
        }
        return null;
    }

    pub fn string(self: Self, stream: anytype) !void {
        for (self.statements) |st| {
            try stream.print(st.string());
        }
    }
};

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
        try stream.print(" {s} = ", name);
        if (self.value) |value| {
            try value.print(stream);
        }
        try stream.print(";");
    }
};

const ReturnStatement = struct {
    tk: token.Token,
    returnValue: ?Expression,

    const Self = @This();

    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }

    pub fn string(self: Self, stream: anytype) !void {
        const rt = self.tk.literal;
        try stream.print("{s} ", rt);
        if (self.returnValue) |value| {
            try value.print(stream);
        }
        try stream.print(";");
    }
};

const ExpressionStatement = struct {
    tk: token.Token,
    expression: ?Expression,

    const Self = @This();
    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }

    pub fn string(self: Self, stream: anytype) !void {
        if (self.expression) |expr| {
            try stream.print(expr.string());
        }
        try stream.print(";");
    }
};

const IntegerLiteral = struct {
    tk: token.Token,
    value: u64,

    const Self = @This();
    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }

    pub fn string(self: Self, stream: anytype) !void {
        try stream.print(self.tk.literal);
        try stream.print(";");
    }
};

const PrefixExpression = struct {
    tk: token.Token,
    operator: []const u8,
    right: Expression,

    const Self = @This();
    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }

    pub fn string(self: Self, stream: anytype) !void {
        try stream.print("(");
        try stream.print(self.operator);
        try stream.print(self.right.string());
        try stream.print(")");
    }
};

const InfixExpression = struct {
    tk: token.Token,
    left: Expression,
    operator: []const u8,
    right: Expression,

    const Self = @This();
    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }

    pub fn string(self: Self, stream: anytype) !void {
        try stream.print("(");
        try stream.print(self.left.string());
        try stream.print(self.operator);
        try stream.print(self.right.string());
        try stream.print(")");
    }
};

const Boolean = struct {
    tk: token.Token,
    value: bool,

    const Self = @This();
    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }

    pub fn string(self: Self, stream: anytype) !void {
        try stream.print(self.tk.literal);
    }
};

const IfExpression = struct {
    tk: token.Token,
    condition: Expression,
    consequence: BlockStatement,
    alternative: ?BlockStatement,

    const Self = @This();
    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }

    pub fn string(self: Self, stream: anytype) !void {
        try stream.print("if");
        try self.condition.string(stream);
        try stream.print(" ");
        try self.consequence.string(stream);
        if (self.alternative) |alt| {
            try stream.print("else ");
            try alt.string(stream);
        }
    }
};

const BlockStatement = struct {
    tk: token.Token,
    statements: []Statement,

    const Self = @This();
    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }

    pub fn string(self: Self, stream: anytype) !void {
        for (self.statements) |st| {
            try st.string(stream);
        }
    }
};

const FunctionLiteral = struct {
    tk: token.Token,
    parameters: []Identifier,
    body: BlockStatement,

    const Self = @This();
    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }

    pub fn string(self: Self, stream: anytype) !void {
        try stream.print(self.tokenLiteral());
        try stream.print("(");
        for (0.., self.parameters) |i, st| {
            try st.string(stream);
            if (i != self.parameters.len - 1) {
                try stream.print(",");
            }
        }
        try stream.print(")");
        try self.body.string(stream);
    }
};

const CallExpression = struct {
    tk: token.Token,
    function: Expression,
    arguments: []Expression,

    const Self = @This();
    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }

    pub fn string(self: Self, stream: anytype) !void {
        try self.function.string(stream);
        try stream.print("(");
        for (0.., self.arguments) |i, arg| {
            try arg.string(stream);
            if (i != self.parameters.len - 1) {
                try stream.print(",");
            }
        }
        try stream.print(")");
    }
};

const StringLiteral = struct {
    tk: token.Token,
    value: []const u8,

    const Self = @This();
    pub fn tokenLiteral(self: Self) []const u8 {
        return self.tk.literal;
    }

    pub fn string(self: Self, stream: anytype) !void {
        try stream.print(self.tk.literal);
    }
};

const ArrayLiteral = struct {};
const IndexExpression = struct {};
const HashLiteral = struct {};
