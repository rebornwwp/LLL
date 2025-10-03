// Say you have a function that returns a POJO with some 
// methods and properties, like so:
function getService(a) {
    return {
        baseUrl: "https://contoso.com/api",
        a: "hello"
    }
}

//
const getServiceDummy = (false as true) && getService(undefined)
type MyService = typeof getServiceDummy

// MyServide就会是返回的object的接口，然后直接就能拿来使用
function AppCtrl(service: MyService) {
    console.log(service.baseUrl)
    console.log(service.a)
    // 报错console.log(service.b)
}
// Useful for getting the "shape" of a function's 
// return value when you don't want/need to declare 
// an interface for that object.

// 如果没有as 如果是false && getService(undefined) 或者是 true && getService(undefined)
// 第一个中返回的结果是一个boolean，第二个中代码就会顺序的执行下去，也就是函数会立即执行

// (false as true) gives us the best of both worlds 
// - the function won't be called at runtime and the 
// cast to true tricks the TypeScript compiler into 
// thinking that the variable will have the value of 
// the function return value.

