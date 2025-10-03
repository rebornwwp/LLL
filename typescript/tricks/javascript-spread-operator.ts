function foo1(x, y, z) {
  return x + y + z
}
let args: [number, number, number] = [1, 2, 3];

// 想将 args 中的三个参数，传入 foo 函数中
foo1.apply(null, args)

console.log(foo1(...args))

let list = [1, 2]
console.log([...list, 2, 3])
console.log([0, ...list, 4])

const point2D = {x: 1, y: 2}
const point3D = {...point2D, z: 3};
const anotherPoint3D = {x: 5, z: 4, ...point2D};
console.log(anotherPoint3D); // {x: 1, y: 2, z: 4}
const yetAnotherPoint3D = {...point2D, x: 5, z: 4}
console.log(yetAnotherPoint3D); // {x: 5, y: 2, z: 4}

const foo = {a: 1, b: 2, c: 0};
const bar = {c: 1, d: 2};
/** Merge foo and bar */
const fooBar = {...foo, ...bar};
// fooBar is now {a: 1, b: 2, c: 1, d: 2}