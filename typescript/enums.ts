enum Direction {
    Up = 1,
    Down,
    Left,
    Right,
}

enum Responses {
    No = 0,
    Yes = 1,
}

function respond(recipient: string, message: Responses): void {
    //...
}

respond("hello", Responses.No);

// 字符串枚举
enum Direction1 {
    Up = "UP",
    Down = "DOWN",
    Left = "LEFT",
    Right = "RIGHT",
}

enum FileAccess {
    // constant members
    None,
    Read = 1 << 1,
    Write = 1 << 2,
    ReadWrite = Read | Write,
    // computed member
    G = "123".length,
}

// const 枚举
const enum Enum {
    A = 1,
    B = A * 2,
}

let directions = [Direction.Up, Direction.Down, Direction.Left, Direction.Right]
console.log(directions)

// 外部枚举
declare enum A {
    A = 1,
    B,
    C = 2,
}

