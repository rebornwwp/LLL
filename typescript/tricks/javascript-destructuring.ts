let rect = { x: 0, y: 10, width: 15, height: 20 }
let { x, y, width } = rect
console.log(x)

const obj = { "some property": "some value" }
const { "some property": someProperty } = obj
console.log(someProperty)

let { w, ...remaining } = { w: 1, x: 2, y: 3, z: 4 }
console.log(w, remaining)

let u = 1, i = 2;
console.log(u, i);
[u, i] = [i, u]
console.log(u, i);

// Array Destructuring with ignores
let [o, , ...rem] = [1, 2, 3, 4, 5]
console.log(o, rem)
