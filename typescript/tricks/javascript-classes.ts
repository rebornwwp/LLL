class Point {
  x: number
  y: number
  constructor(x: number, y: number) {
    this.x = x
    this.y = y
  }

  add(point: Point) {
    return new Point(this.x + point.x, this.y + point.y)
  }
}

// generates the following js on es5
// var Point = (function () {
//   function Point(x, y) {
//       this.x = x;
//       this.y = y;
//   }
//   Point.prototype.add = function (point) {
//       return new Point(this.x + point.x, this.y + point.y);
//   };
//   return Point;
// })();

let p1 = new Point(0, 10)
let p2 = new Point(10, 20)
let p3 = p1.add(p2)

console.log(p3.x)
console.log(p3.y)

// inheritance
class Point3D extends Point {
  z: number
  constructor(x: number, y: number, z: number) {
    super(x, y)
    this.z = z
  }

  add(point: Point3D) {
    let point2D = super.add(point)
    return new Point3D(point2D.x, point2D.y, this.z + point.z)
  }
}

// static
class Something {
  static instances = 0
  constructor() {
    Something.instances++
  }
}

let s1 = new Something()
let s2 = new Something()
console.log(Something.instances)

// Access Modifiers

// accessible on	  public	protected	private
// class            yes   	yes	      yes
// class children	  yes   	yes	      no
// class instances  yes   	no	      no

class FooBase {
  public x: number
  private y: number
  protected z: number
}

let foo = new FooBase()
foo.x
// foo.y // y是私有的，只能在类中被使用
// foo.z // z是被保护的，能在类中和子类中被使用

class FooChild extends FooBase {
  constructor() {
    super()
    this.x
    // this.y // y是私有的，只能在类中被使用
    this.z
  }
}

// abstract
// abstract classes cannot be directly instantiated. Instead the user must create some class that inherits from the abstract class.
// abstract members cannot be directly accessed and a child class must provide the functionality.
// 生成抽象类再es中不像其他语言可能有个abstract关键字就能表示，需要自己用一些套路来实现

// constructor is optinal
class Foo { }
let foo1 = new Foo()
console.log(foo1)

// define using constructor
class Fooo {
  x: number
  constructor(x: number) {
    this.x = x
  }
}
// 等价于
class Foooo {
  constructor(public x: number) {
    this.x = x
  }
}

// Property initializer
// You can initialize any member of the class outside the class constructor, useful to provide default (notice members = [])
class Fooooo {
  members = []
  add(x) {
    this.members.push(x)
  }
}
