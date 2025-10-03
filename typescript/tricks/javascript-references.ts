// 下面bar=foo这个形式其实是创建一个引用，两个都是指代同一个对象
let foo = { baz: 1 }
let bar = foo
foo.baz = 124
console.log(bar.baz)

let baz = {}

console.log(foo == bar)
console.log(foo == baz)
