// basic annotations
let num: number = 123

function identify(num: number): number {
  return num
}

// primitive types
let str: string
let bool: boolean
str = "hello world"
bool = true

// arrays
let boolArray: boolean[]
boolArray = [true, false]

// interface
interface Name {
  fistName: string
  lastName: string
}

// inline type annotation
let na: {
  first: string
  second: string
}

// special types ------ any, null, undefined, void
let power: any
power = 123
power = '123'

// Use :void to signify that a function does not have a return type:
function log(message): void {
  console.log(message)
}

// generics
function reverse<T>(items: T[]): T[] {
  let toreturn = [] as T[]
  for (let i = items.length - 1; i >= 0; i--) {
    toreturn.push(items[i])
  }
  return toreturn
}

interface Array<T> {
  reverse(): T[]
  // ...
}

// intersection type
function extend<T, U>(first: T, second: U): T & U {
  let result = <T & U>{}
  for (let id in first) {
    result[id] = first[id]
  }
  for (let id in second) {
    if (!result.hasOwnProperty(id)) {
      result[id] = second[id]
    }
  }
  return result
}
let x = extend({ a: "hello" }, { b: 42 })
console.log(x.a)
console.log(x.b)

// tuple type
let nameNumber: [string, number]

nameNumber = ['Jenny', 87238912]

// type alias
type StrOrNum = string | number
let sample: StrOrNum
sample = 123
sample = 'hello'

type Text1 = string | { text: string };
type Coordinates1 = [number, number];
type Callback = (data: string) => void;
