let inc = (x) => x + 1

class Person {
  constructor(public age: number) { }
  growOld = () => {
    this.age++
  }
  growOlder() {
    this.age = this.age + 2
  }
}

let person = new Person(1)
person.growOld()
person.growOld()
console.log(person.age)

// 上面的person实例中 growOld是箭头函数，而growOlder是普通的定义函数
// 感觉箭头函数会有闭包的样子，能够将this保存起来，但是在你普通函数中这个定义是不行的
let growOld = person.growOld
growOld()
console.log(person.age)
let growOlder = person.growOlder
growOlder()
growOld()
console.log(person.age)

// Arrow functions with libraries that use this
// let _self = this
// something.each(function () {
//   console.log(_self)
//   console.log(this)
// })

// Arrow functions and inheritance
class Adder {
  constructor(public a: number) { }
  add = (b: number) => {
    return this.a + b
  }
}

class Child extends Adder {
  callAdd(b: number) {
    return this.add(b)
  }
}

const child = new Child(123)
console.log(child.callAdd(123))

class BetterAdder {
  constructor(public a: number) { }
  add = (b: number): number => {
    return this.a + b
  }
}

class BetterChild extends BetterAdder {
  private superAdd = this.add
  add = (b: number): number => {
    return this.superAdd(b)
  }
}

// Quick object return
let foo = () => ({
  bar: 123
})
console.log(foo())