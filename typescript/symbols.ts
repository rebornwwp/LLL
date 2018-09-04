// 创建
let sym1 = Symbol();
let sym2 = Symbol("key");

console.log(sym1);
console.log(sym2);

// 不可变且唯一的
let sym3 = Symbol("key");
let sym4 = Symbol("key");

console.log(sym3 === sym4);

// symbol 作为对象属性的键
let obj = {
    [sym1]: "value",
};

console.log(obj)

const getClassNameSymbol = Symbol();

class C {
    [getClassNameSymbol]() {
        return "C";
    }
}

let c = new C();
let className = c[getClassNameSymbol](); // "C"

console.log(c);
console.log(className);