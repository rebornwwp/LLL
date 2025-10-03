// Boolean
let isDone: boolean = false;

console.log(isDone);

// Number
let decimal: number = 6;
let hex: number = 0xf00d;
let binary: number = 0b1010;
let octal: number = 0o744;

console.log(decimal);
console.log(hex);
console.log(binary);
console.log(octal);

// string
let color: string = "blue";
color = "red";
console.log(color);

let fullName: string = `Bob Bobbington`;
let age: number = 27;
let sentence: string = `Hello, my name is ${fullName}. age is ${age + 1} years old next month`;
console.log(sentence);

// array
let list: number[] = [1, 2, 3];
let l: Array<number> = [1, 2, 3];
console.log(list);
console.log(l);

// tuple
let x: [string, number];
x = ["hello", 10];
console.log(x);

// enum
enum Color { Red, Green, Blue }
let c: Color = Color.Green
console.log(c)

// any
let notSure: any = 5;
notSure = "maybe a string instead";
notSure = false;
console.log(notSure);

// void
function warnUser(): void {
    console.log("this is my warning message");
}

// null undefined
let u: undefined = undefined
let n: null = null

console.log(u)
console.log(n)

// never
function error(message: string): never {
    throw new Error(message);
}

function fail() {
    return error("Something wrong");
}

function infiniteLoop(): never {
    while (true) {
    }
}

// 类型推断
let someValue: any = "this is a string"

// <> 用法
let strLength: number = (<string>someValue).length
// as 用法
let strLen: number = (someValue as string).length

