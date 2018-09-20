// iterator and for of
// Iterator 接口的目的，就是为所有数据结构，提供了一种统一的访问机制，即for...of循环
// 一种数据结构只要部署了 Iterator 接口，我们就称这种数据结构是“可遍历的”（iterable）
// 默认的 Iterator 接口部署在数据结构的Symbol.iterator属性，或者说，一个数据结构只要
// 具有Symbol.iterator属性，就可以认为是“可遍历的”（iterable）。Symbol.iterator属
// 性本身是一个函数，就是当前数据结构默认的遍历器生成函数。执行这个函数，就会返回一个遍历
// 器。至于属性名Symbol.iterator，它是一个表达式，返回Symbol对象的iterator属性，这是
// 一个预定义好的、类型为 Symbol 的特殊值，所以要放在方括号内

let arr = ['a', 'b', 'c'];
let iter = arr[Symbol.iterator]();

a = iter.next();
console.log(a);
console.log(iter.next());

class RangeIterator {
  constructor(start, stop) {
    this.value = start;
    this.stop = stop;
  }

  [Symbol.iterator]() { return this }

  next() {
    let value = this.value;
    if (value < this.stop) {
      this.value++;
      return { done: false, value: value };
    }
    return { done: true, value: undefined }
  }
}

function range(start, stop) {
  return new RangeIterator(start, stop);
}

for (let i of range(1, 10)) {
  console.log(i);
}

// 遍历器实现指针结构的例子
function Obj(value) {
  this.value = value;
  this.next = null;
}

Obj.prototype[Symbol.iterator] = function () {
  var iterator = { next: next };
  var current = this;

  function next() {
    if (current) {
      var value = current.value;
      current = current.next;
      return { done: false, value: value }
    } else {
      return { done: true };
    }
  }
  return iterator
}

var one = new Obj(1);
var two = new Obj(2);
var three = new Obj(3);
one.next = two;
two.next = three;
for (let i of one) {
  console.log(i);
}

// 调用 Iterator 接口的场合
// 1 解构赋值
let set = new Set().add('a').add('b').add('c');

let [x, y] = set;
console.log(x);
console.log(y);

// 2 扩展运算符
let str = 'hello';
console.log([...str])
let arr1 = ['b', 'c'];
console.log(['a', ...arr1, 'd']);

// 3 yield
// yield*后面跟的是一个可遍历的结构，它会调用该结构的遍历器接口

// 4 其他场合

// 由于数组的遍历会调用遍历器接口，所以任何接受数组作为参数的场合，其实都调用了遍历器接口。下面是一些例子。

//     for...of
//     Array.from()
//     Map(), Set(), WeakMap(), WeakSet()（比如new Map([['a',1],['b',2]])）
//     Promise.all()
//     Promise.race()

// 字符串的 Iterator 接口
// 字符串是一个类似数组的对象，也原生具有 Iterator 接口。

let arr2 = [3, 5, 7];
arr2.foo = 'hello';

for (let i in arr2) {
  console.log(i); // "0", "1", "2", "foo"
}

for (let i of arr2) {
  console.log(i); //  "3", "5", "7"
}

// set and map
var engines = new Set(["Gecko", "Trident", "Webkit", "Webkit"]);
for (var e of engines) {
  console.log(e);
}

var es6 = new Map();
es6.set("edition", 6);
es6.set("committee", "TC39");
es6.set("standard", "ECMA-262");
for (var [name, value] of es6) {
  console.log(name + ": " + value);
}
// entries keys values
let arr3 = ['a', 'b', 'c'];
for (let pair of arr.entries()) {
  console.log(pair);
}

let arrayLike = { length: 2, 0: 'a', 1: 'b' }; // 没有iterator接口
for (let x of Array.from(arrayLike)) {
  console.log(x);
}

// 对象变量的遍历
let ess = {
  edition: 6,
  committee: "TC39",
  standard: "ECMA-262"
};

for (let e in ess) {
  console.log(e);
}

// 报错
// for (let e of ess) {
//   console.log(e);
// }

// 下面是两种对对象遍历
// for (var key of Object.keys(someObject)) {
//   console.log(key + ': ' + someObject[key]);
// }

// function* entries(obj) {
//   for (let key of Object.keys(obj)) {
//     yield [key, obj[key]];
//   }
// }
// for (let [key, value] of entries(obj)) {
//   console.log(key, '->', value);
// }

// 其他的遍历方法
let myArray = [1, 2, 3, 4, 5, 6];
for (var index = 0; index < myArray.length; index++) {
  console.log(myArray[index]);
}

myArray.forEach(function (value) {
  console.log(value);
});