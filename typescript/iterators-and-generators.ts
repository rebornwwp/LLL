// 当一个对象实现了Symbol.iterator属性时，我们认为它是可迭代的
let someArray = [1, "string", false];
for (let entry of someArray) {
    console.log(entry);
}
// for..of vs. for..in 语句
// for..of和for..in均可迭代一个列表；但是用于迭代的值却不同，for..in迭代的是对象的 键 的列表，而for..of则迭代对象的键对应的值。

let li = [4, 5, 6];
for (let i in li) {
    console.log(i); // 0 1 2
}

for (let v of li) {
    console.log(v); // 4 5 6
}

let pets = new Set(["Cat", "Dog", "Hamster"]);
pets["species"] = "mammals";

for (let pet in pets) {
    console.log(pet); // "species"
}

for (let pet of pets) {
    console.log(pet); // "Cat", "Dog", "Hamster"
}
