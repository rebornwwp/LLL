function identity<T>(arg: T): T {
    return arg;
}

let output = identity<string>("hello world");
console.log(output);

function loggingIdentity<T>(arg: T[]): T[] {
    console.log(arg.length);
    return arg;
}

let myIdentity: <T>(arg: T) => T = identity;

let myIdentity1: { <T>(arg: T): T } = identity;

// 泛型类
class GenericNumber<T>{
    zeroValue: T;
    add: (x: T, y: T) => T;
}

let myGenericNumber = new GenericNumber<number>();
myGenericNumber.zeroValue = 0;
myGenericNumber.add = function (x, y) { return x + y };

// 泛型约束
interface lengthwise {
    length: number;
}

function loggingIdentity1<T extends lengthwise>(arg: T): T {
    console.log(arg.length);
    return arg;
}

loggingIdentity1([1, 2, 3, 4, 5, 6]);
loggingIdentity1({ length: 10, value: 3 })

//在泛型中使用类类型
function create<T>(c: { new(): T; }): T {
    return new c();
}

class BeeKeeper {
    hasMask: boolean;
}

class ZooKeeper {
    nametag: string;
}

class Animals {
    numLegs: number;
}

class Bee extends Animals {
    keeper: BeeKeeper;
}

class Lion extends Animals {
    keeper: ZooKeeper;
}

function createInstance<A extends Animals>(c: new () => A): A {
    return new c();
}

createInstance(Lion).keeper.nametag;  // typechecks!
createInstance(Bee).keeper.hasMask;   // typechecks!