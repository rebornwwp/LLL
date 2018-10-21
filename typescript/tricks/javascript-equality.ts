// Equality
// console.log("" == "0"); // false
// console.log(0 == ""); // true

// console.log("" === "0"); // false
// console.log(0 === ""); // false

// 以上代码在js中都是成立的
// 但是在ts中必须注意，这样的写法会有错误，对两个类型都不相同的值进行比较是错误的


// Structural Equality
console.log({ a: 123 } == { a: 123 })
console.log({ a: 123 } === { a: 123 })
// 上面这个比较其实只是对只想object的指针的比较，所以很显然这样是不行的
// 需要自己用一个deepEqual的函数来进行比较

type IdDisplay = {
    id: string
    display: string
}

const list: IdDisplay[] = [
    {
        id: 'foo',
        display: 'foo select',
    },
    {
        id: 'bar',
        display: 'bar select',
    }
]

const fooIndex = list.map(i => i.id).indexOf('foo')
console.log(fooIndex)



