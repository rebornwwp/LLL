// JavaScript (and by extension TypeScript) has two bottom types : null and undefined. They are intended to mean different things:
// Something hasn't been initialized : undefined.
// Something is currently unavailable: null.

console.log(undefined == undefined)
console.log(null == undefined)
console.log(null == null)
// 上面这个说明一个道理null和undefined是差不多等价的
// 所以可以==null来检测undefined和null
console.log(0 == undefined)
console.log('' == undefined)
console.log(false == undefined)

function foo(arg: string | null | undefined) {
  // 所以可以==null来检测undefined和null
  if (arg == null) {
    console.log("the arg is null or undefined")
  } else {
    console.log(arg)
  }
}

foo(null)
foo(undefined)
foo("hello world")

// checking for root level undefined
let someGlobal
if (typeof someGlobal !== 'undefined') {
  console.log(someGlobal)
} else {
  console.log("the global variable is undefined")
}

// limit explicit use of nudefined
// js style
// function foo(){
//   // if Something
//   return {a:1,b:2};
//   // else
//   return {a:1,b:undefined};
// }

// ts style
function limit(): { a: number, b?: number } {
  return { a: 1, b: 2 }
  // or return {a:1}
}

// node style callbacks
// fs.readFile('someFile', 'utf8', (err,data) => {
//   if (err) {
//     // do something
//   } else {
//     // no error
//   }
// });

// 如果是想好好写代码，就讲上面的代码封装成Promises的形式，这样就不会出现上面有
// 判断的代码，直接用then，catch就行了


// dont use undefined as a means of denoting validity

// 这个是用undefined来代替返回的是否为可靠的
function toInt(str: string) {
  return str ? parseInt(str) : undefined
}

// better write
function toInt1(str: string): { valid: boolean, int?: number } {
  const int = parseInt(str)
  if (isNaN(int)) {
    return { valid: false }
  } else {
    return { valid: true, int }
  }
}