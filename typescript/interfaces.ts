interface LabelledValue {
    label: string;
}

function printLabel(labelledObj: LabelledValue) {
    console.log(labelledObj.label);
}

let myObj = { size: 10, label: "size 10 object" };
printLabel(myObj)

interface SquareConfig {
    color?: string;
    width?: number;
}

function createSquare(config: SquareConfig): { color: string, area: number } {
    let newSquare = { color: "white", area: 100 };
    if (config.color) {
        newSquare.color = config.color;
    }
    if (config.width) {
        newSquare.area = config.width * config.width;
    }
    return newSquare;
}

let mySquare = createSquare({ color: "black" })
console.log(mySquare)

// 只读属性
interface Point {
    readonly x: number;
    readonly y: number;
}

let p1: Point = { x: 10, y: 20 };
console.log(p1);
console.log(p1.x);
console.log(p1.y);

let ro: ReadonlyArray<number> = [1, 2, 3, 4, 5];
console.log(ro);
console.log(ro.length);
