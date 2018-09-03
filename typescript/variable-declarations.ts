// let
let hello = "Hello!";

// 块作用域
function f(input: boolean): number {
    let a = 100;
    if (input) {
        let b = a + 1;
        return b;
    }
    return a
}

function ifElse(condition: boolean, x: number) {
    if (condition) {
        let x = 100;
        return x;
    }
    return x;
}

console.log(ifElse(false, 0));
console.log(ifElse(true, 0));

for (let i = 0; i < 10; i++) {
    console.log(i);
}

// const
const numLivesForCat = 9;
console.log(numLivesForCat);
const kitty = {
    name: "Aurora",
    numLives: numLivesForCat,
}

// 解析
let input = [1, 2];
let [first, second] = input;
console.log(first);
console.log(second);
// swap variables
[first, second] = [second, first];
let [a1, ...a2] = [1, 2, 3, 4];
console.log(a1);
console.log(a2);

let [, d, , e] = [1, 2, 3, 4]

let o = {
    a: "foo",
    b: 12,
    c: "bar",
};
let { a, b }: { a: string, b: number } = o;

let { a: newName1, b: newName2 } = o;
console.log(newName1);
console.log(newName2);

function keepWhileObject(wholeObject: { a: string, b?: number }) {
    let { a, b = 101 } = wholeObject;
    console.log(a);
    console.log(b);
}

keepWhileObject(o);
keepWhileObject({ a: "hello" })

// 函数声明
type C = { a: string, b?: number }
function func({ a, b }: C): void {

}

// 展开
let b1 = [1, 2]
let b2 = [3, 4]
console.log([0, ...b1, ...b2, 5])

let defaults = { food: "spicy", price: "$$", ambiance: "noisy" };
let search = { ...defaults, food: "rich" };
console.log(search)
console.log(defaults)