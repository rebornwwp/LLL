// let命令
{
    let a = 10;
    var b = 1;
}

// let声明的变量有作用域,所以在全局变量中只有b没有a
console.log(b);

// for循环很适合用let
for (let i = 0; i < 10; i++) {
    console.log(i);
}

var a = [];
for (var i = 0; i < 10; i++) {
    a[i] = function () {
        console.log(i);
    };
}
console.log(a[6]()); // 输出10

var a = [];
for (let i = 0; i < 10; i++) {
    a[i] = function () {
        console.log(i);
    };
}
console.log(a[6]()); // 输出6

// for循环还有一个特别之处，就是设置循环变量的那部分是一个父作用域，而循环体内部是一个单独的子作用域。
for (let i = 0; i < 3; i++) {
    let i = 'abc'; // 独立的作用域
    console.log(i);
}

// var 的情况
console.log(foo);
// 命令式语言，变量申明在使用时候，foo为undefined
var foo = 2;

// let 的情况
// console.log(bar); // 报错ReferenceError
// let bar = 2;



// 不允许重复声明
function func() {
    let a = 10; // 错误
    var a = 1;
}

function func(arg) {
    // let arg; // 错误
    {
        let arg; // 独立的作用域就能使用
    }
}

// let使得JavaScript具有了块级作用域
function f1() {
    let n = 5;
    if (true) {
        let n = 10;
    }
    console.log(n); // 5
}

// ES5 规定，函数只能在顶层作用域和函数作用域之中声明，不能在块级作用域声明。 ES6中这样的形式是可以的
if (true) {
    function f() { console.log("hello world"); }
}

f()

try {
    function f() { }
} catch (e) {
    // ...
}

function f() {
    console.log('I am outside function.');
}

f();

// const命令
// const声明一个只读的常量。一旦声明，常量的值就不能改变。

const PI = 3.1415;
// PI = 2; // 错误

// const实际上保证的，并不是变量的值不得改动，而是变量指向的那个内存地
// 址所保存的数据不得改动。对于简单类型的数据（数值、字符串、布尔值），值就
// 保存在变量指向的那个内存地址，因此等同于常量。但对于复合类型的数据（主要
// 是对象和数组），变量指向的内存地址，保存的只是一个指向实际数据的指针，
// const只能保证这个指针是固定的（即总是指向另一个固定的地址），至于它指向
// 的数据结构是不是可变的，就完全不能控制了。因此，将一个对象声明为常量必须
// 非常小心。

const foo1 = {};

// 为 foo 添加一个属性，可以成功
foo1.prop = 123;
foo1.prop // 123

const ab = [];
ab.push('hello'); // 可行
ab.length = 0;
// a = ['Dave']; // 错误

// 如果真的想将对象冻结，应该使用Object.freeze方法。
const foo2 = Object.freeze({})

// 将对象本身冻结，对象的属性也应该冻结。下面是一个将对象彻底冻结的函数。
var constantize = (obj) => {
    Object.freeze(obj);
    Object.keys(obj).forEach((key, i) => {
        if (typeof obj[key] === 'object') {
            constantize(obj[key]);
        }
    });
};