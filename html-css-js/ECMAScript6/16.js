// Generator 函数有多种理解角度。语法上，首先可以把它理解成，Generator 函数是一个状态机，封装了多个内部状态。

// 执行 Generator 函数会返回一个遍历器对象，也就是说，Generator 
// 函数除了状态机，还是一个遍历器对象生成函数。返回的遍历器对象，可以依
// 次遍历 Generator 函数内部的每一个状态。

// 形式上，Generator 函数是一个普通函数，但是有两个特征。一是，function
// 关键字与函数名之间有一个星号；二是，函数体内部使用yield表达式，定义不同的内
// 部状态（yield在英语里的意思就是“产出”）

function* helloworldGenerator() {
  yield 'hello';
  yield 'world';
  return 'ending';
}
let hw = helloworldGenerator();

for (let i of hw) {
  console.log(i);
}

function* f() {
  for (var i = 0; true; i++) {
    var reset = yield i;
    if (reset) { i = -1; }
  }
}

var g = f();

g.next() // { value: 0, done: false }
g.next() // { value: 1, done: false }
g.next(true) // { value: 0, done: false }

// Generator.prototype.throw()

var g = function* () {
  try {
    yield;
  } catch (e) {
    console.log('内部捕获', e);
  }
};

var i = g();
i.next();

try {
  i.throw('a');
  i.throw('b');
} catch (e) {
  console.log('外部捕获', e);
}

// Generator.prototype.return()
// Generator 函数返回的遍历器对象，还有一个return方法，可以返回给定的值，并且终结遍历 Generator 函数。
function* gen() {
  yield 1;
  yield 2;
  yield 3;
}

var g = gen();

g.next()        // { value: 1, done: false }
g.return('foo') // { value: "foo", done: true }
g.next()        // { value: undefined, done: true }
// next()、throw()、return()这三个方法本质上是同一件事，
// 可以放在一起理解。它们的作用都是让 Generator 函数恢复执行，并且使用不同的语句替换yield表达式。
// 如果在 Generator 函数内部，调用另一个 Generator 函数，默认情况下是没有效果的。