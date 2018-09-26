# Basic Types

``` typescript
// Boolean
let isDone: Boolean = false;

// Number
let decimal: number = 5;
let hex: number = 0xf00d;
let binary: number = 0b1010;
let octal: number = 0o700;

// String
let color: string = "blue";
color = 'red';

let fullname: string = `Bob Bobbington`;
let age: number = 37;
let sentence: string = `Hello, my name is ${ fullname }.
  I'll be ${ age + 1 } years old next month`;
let sentence: string = "Hello, my name is " + fullName + ".\n\n" +
    "I'll be " + (age + 1) + " years old next month.";

// Array
let list: number[] = [1, 2, 3];
let list: Array<number> = [1, 2, 3];

// Tuple
let x: [string, number];
x = ["hello", 10];
console.log(x);

// Enum
enum Color {Red, Green, Blue}
let x: Color = Color.Green;

enum Color {Red = 1, Green, Blue}
let x: Color = Color.Green;

enum Color {Red = 1, Green = 2, Blue = 4}
let c: Color = Color.Green;

// Any
let notSure: any = 4;
notSure = "maybe a string instead";
notSure = false;

// Void
// void is a little like the opposite of any: the absence of having any type at all. 
function warnUser(): void {
  alert("This is my warning message");
}

// Null and Undefined
let u: undefined = undefined;
let n: null = null;

// Never
// Function returning never must have unreachable end point
function error(message: string): never {
    throw new Error(message);
}

// Inferred return type is never
function fail() {
  return error("Something failed");
}

// Function returning never must have unreachable end point
function infiniteLoop(): never {
  while (true) {
  }
}

// Object
declare function create(o: object | null): void;

create({ prop: 0 });
create(null);

// Type assertions
let someValue: any = "this is a string";

let strLength: number = (<string>someValue).length;
```

# Variable Declarations

``` typescript
let and const

// array Destructuring
let input = [1, 2];
let [first, second] = input;

// swap variables
[first, second] = [second, first]

let [first, ...rest] = [1, 2, 3, 4];
console.log(first);
console.log(rest);

let [, second, , fourth] = [1, 2, 3, 4];

// object destructuring
let o = {
  a: "foo",
  b: 12,
  c: "bar",
};
let {a, b} = 0;

let { a, ...passthrough } = o;
let total = passthrough.b + passthrough.c.length;

// property renaming
let { a: newName1, b: newName2 } = o;

let newName1 = o.a;
let newName2 = o.b;
// default values
function keepWholeObject(wholeObject: { a: string, b?: number }) {
    let { a, b = 1001 } = wholeObject;
}

// function declarations
type C = { a: string, b?: number }
function f({ a, b }: C): void {
  // ...
}

// spread
let first = [1, 2];
let second = [3, 4];
let bothPlus = [0, ...first, ...second, 5];

```