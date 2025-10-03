// 数组的解构赋值
let [a, b, c] = [1, 2, 3];

// 如同模式匹配一样
let [foo, [[bar], baz]] = [1, [[2], 3]];
console.log(foo);
console.log(bar);
console.log(baz);

let [, , third] = ["foo", "bar", "baz"];

let [x, , y] = [1, 2, 3];
let [head, ...tail] = [1, 2, 3, 4];
let [q, w, ...e] = ['a'];
console.log(q);
console.log(w);
console.log(e);

// 解构不成功就变成undefined

// 不完全解构
let [u, i] = [1, 2, 3];
let [h, [j]] = [1, [2, 3, 4]]
console.log(j);

// 对set也可以解构
let [m, n, v] = new Set(['a', 'b', 'c']);
console.log(m);

// 默认值的解构

let [g = 1] = [];
console.log(g);

// 对象的解构
let { qwe, wer } = { qwe: "aaa", wer: "bbb" };
console.log(qwe);

// 属性的解构
let { length: len } = 'hello';
console.log(len);

// 将获得其内部函数
let { toString: s } = 123;

// 函数的解构 模式匹配加上默认值
function add([x = 1, y = 1]) {
    return x + y;
}


// 一般用途
// 交换变量
let aa = 1;
let bb = 2;
[aa, bb] = [bb, aa];

// 从函数返回多个值
function example() {
    return [1, 2, 3];
}
let [e1, e2, e3] = example();

function example1() {
    return {
        e11: 1,
        e22: 2,
    }
}

let { e11, e22 } = example1();
console.log(e1);
console.log(e11);

// 提取 JSON 数据
let jsonData = {
    id: 42,
    status: "OK",
    data: [867, 5309]
};

let { id, status, data: number } = jsonData;

console.log(id, status, number);

// 函数参数的默认值
ajax = function (url, {
    async = true,
    beforeSend = function () { },
    cache = true,
    complete = function () { },
    crossDomain = false,
    global = true,
    // ... more config
} = {}) {
    // ... do stuff
};

// 遍历 Map 结构

const map = new Map();
map.set('first', 'hello');
map.set('second', 'world');

for (let [key, value] of map) {
    console.log(key + " is " + value);
}

// 获取键名
for (let [key] of map) {
    console.log(key);
}

// 获取键值
for (let [, value] of map) {
    console.log(value);
}

// 输入模块的指定方法
// const { SourceMapConsumer, SourceNode } = require("source-map");