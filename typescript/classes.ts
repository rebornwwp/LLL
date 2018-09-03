class Greeter {
    greeting: string;
    constructor(message: string) {
        this.greeting = message;
    }
    greet() {
        return "Hello, " + this.greeting;
    }
}

let greeter = new Greeter("World");
console.log(greeter);

// 继承
class Animal {
    // public name: string;
    private a: string; // 无法在类的外部被访问
    public constructor(private name: string) { }
    public move(distanceInMeters: number = 0) {
        console.log(`${this.name} moved ${distanceInMeters}m.`);
    }
}

class Dog extends Animal {
    bark() {
        console.log('Woof! woof!');
    }
}

const dog = new Dog('dog');
dog.bark();
dog.move(10);
dog.bark();

class Snake extends Animal {
    constructor(theName: string) {
        super(theName);
    }
    move(distanceInMeters = 5) {
        console.log("Slithering...");
        super.move(distanceInMeters);
    }
}

class Horse extends Animal {
    constructor(name: string) {
        super(name);
    }
    move(distanceInMeters = 45) {
        console.log("Galloping");
        super.move(distanceInMeters);
    }
}

let sam = new Snake("Sammy the python");
let tom: Animal = new Horse("Tommy th e");
sam.move();
tom.move(30)

class Person {
    protected name: string;
    // 构造函数也可以被标记成 protected。 这意味着这个类不能在包含它的类外被实例化，但是能被继承
    protected constructor(name: string) {
        this.name = name;
    }
}

class Employee extends Person {
    private department: string;

    constructor(name: string, department: string) {
        super(name);
        this.department = department;
    }

    public getElevatorPitch() {
        return `Hello, my name is ${this.name} and I work in ${this.department}`;
    }
}

// let p = new Person("wang"); //构造函数是受保护的将会报错
let howard = new Employee("Howard", "sales");
console.log(howard)

// readOnly
class Octopus {
    readonly name: string;
    readonly numberOfLegs: number = 8;
    constructor(theName: string) {
        this.name = theName;
    }
}

let dad = new Octopus("Man with the 8 strong legs");
console.log(dad);

// getters and setters

let passcode = "secret passcode";

class Employeee {
    private _fullName: string;

    get fullName(): string {
        return this._fullName;
    }

    set fullName(newName: string) {
        if (passcode && passcode == "secret passcode") {
            this._fullName = newName;
        } else {
            console.log("Error: Unauthorized update of employeee");
        }
    }
}

let em = new Employeee();
em.fullName = "Bob Smith";
console.log(em)

// 静态属性
class Grid {
    static origin = { x: 0, y: 0 };
    calculateDistanceFromOrigin(point: { x: number; y: number; }) {
        let xDist = (point.x - Grid.origin.x);
        let yDist = (point.y - Grid.origin.y);
        return Math.sqrt(xDist * xDist + yDist * yDist) / this.scale;
    }
    constructor(public scale: number) { }
}

let grid1 = new Grid(1.0);  // 1x scale
let grid2 = new Grid(5.0);  // 5x scale

console.log(grid1.calculateDistanceFromOrigin({ x: 10, y: 10 }));
console.log(grid2.calculateDistanceFromOrigin({ x: 10, y: 10 }));
console.log(Grid)

// 抽象类
abstract class Animal1 {
    abstract makeSound(): void;
    move(): void {
        console.log("roaming the search...");
    }
}

// 类当做接口使用
class Point1 {
    x: number;
    y: number;
}

interface Point3d extends Point1 {
    z: number;
}

let point3d: Point3d = { x: 1, y: 2, z: 3 };