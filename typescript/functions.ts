function add(x: number, y: number): number {
    return x + y;
}

let myAdd = function (x: number, y: number): number { return x + y }

let myAdd1: (x: number, y: number) => number =
    function (x: number, y: number): number { return x + y }

function buildName(firstName: string, lastName?: string) {
    if (lastName) {
        return firstName + " " + lastName
    } else {
        return firstName
    }
}

function buildName1(firstName: string, ...restOfName: string[]) {
    return firstName + " " + restOfName.join(" ");
}

let employeeName = buildName1("Joseph", "Samuel", "lucy", "Bob")
console.log(employeeName)

