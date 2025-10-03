// 类
// 定义类

class Point {
  constructor(x, y) {
    this.x = x
    this.y = y
  }

  // 此方法是不可枚举的
  toString() {
    return '(' + this.x + ', ' + this.y + ')'
  }
}

console.log(typeof Point) // function
console.log(Point === Point.prototype.constructor) // true

// 使用方法
let point = new Point(1, 1)
console.log(point)
console.log(point.constructor === Point.prototype.constructor)
console.log(point.hasOwnProperty('x')) // true
console.log(point.hasOwnProperty('toString')) //false
console.log(point.__proto__.hasOwnProperty('toString')) //false

// 注意
// 事实上，类的所有方法都定义在类的prototype属性上面。

// 类的新方法可以通过Object.assign一次性向类添加多个方法
Object.assign(Point.prototype, {
  toValue() { },
  toSt() { },
})

console.log(Object.keys(Point.prototype))
console.log(Object.getOwnPropertyNames(Point.prototype))

let methodName = 'getArgs';

class Square {
  constructor(length) {
    this.length = length
  }

  // 类的属性名，可以采用表达式
  [methodName]() {
    console.log("methodName")
  }
}

let square = new Square(12)
square.getArgs()

// 类的所有实例共享一个原型对象
let p1 = new Point(1, 2)
let p2 = new Point(1, 2)
console.log(p1.__proto__ === p2.__proto__)

// class表达式
// 上面代码使用表达式定义了一个类。需要注意的是，这个类的名字
// 是MyClass而不是Me，Me只在 Class 的内部代码可用，指代当前类。
// 可以省略Me
const MyClass = class Me {
  getClassName() {
    return Me.name
  }
}

// 私有方法和私有属性

// 私有方法是常见需求，但 ES6 不提供，只能通过变通方法模拟实现。
// 第一种做法
class Widget {
  // 公有方法
  foo(baz) {
    this._bar(baz)
  }

  // 私有方法
  _bar(baz) {
    return this.snaf = baz
  }
}

// 第二种做法
class Widget1 {
  foo(baz) {
    bar.call(this, baz);
  }

  // ...
}

function bar(baz) {
  return this.snaf = baz;
}

// 第三种方法 利用Symbol值得唯一性
const bar1 = Symbol('bar')
const snaf = Symbol('snaf')

class MyClass1 {
  // 公有方法
  foo(baz) {
    this[bar](baz);
  }

  // 私有方法
  [bar1](baz) {
    return this[snaf] = baz;
  }
}

// this的指向 指向类的实例
class MyClass2 {
  constructor() {

  }

  get prop() {
    return 'getter'
  }

  set prop(value) {
    console.log('setter: ' + value)
  }
}

// class的generator方法
class Foo {
  constructor(...args) {
    this.args = args
  }
  *[Symbol.iterator]() {
    for (let arg of this.args) {
      yield arg
    }
  }
}

for (let x of new Foo('hello', 'world', 'this')) {
  console.log(x)
}

// 静态方法
// 加上static关键字，就表示该方法不会被实例继承，而是直接通过类来调用，这就称为“静态方法”。
// 如果静态方法包含this关键字，这个this指的是类，而不是实例。
// 父类的静态方法，可以被子类继承。
// 静态方法也是可以从super对象上调用的。
class FooClass {
  static classMethod() {
    return 'hello'
  }
}

class Bar extends FooClass {
  static clssMethod() {
    return super.classMethod() + ', too';
  }
}

Bar.classMethod() // "hello, too"

// 静态属性和实例属性
// 静态属性指的是 Class 本身的属性，即Class.propName

class Foo1 {
}

Foo1.prop = 1;
console.log(Foo1.prop) // 1
