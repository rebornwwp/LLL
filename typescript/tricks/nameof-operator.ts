interface Person {
    firstName: string
    lastName: string
}
type a = keyof Person
// 此时的a等价于"firstName" | "lastName" 即是a表示的值就
// 被限制在"firstName"和"lastName"这两个上了

const nameof = <T>(name: keyof T) => name
// 编译成的js代码是这样的 var nameof = function (name) { return name; };
// 表明其是一个identity函数，但是在ts中代码传入的name是被限制住了，有利于代码安全
const personName = nameof<Person>("firstName")
const personName1 = nameof<Person>("lastName")
console.log(personName)
console.log(personName1)

// 下面的代码就会报错,表示"otherName"
// const otherName = nameof<Person>("otherName")

// nameof Factory
// nameofFactory.ts
// cant
export const nameOfFactory = <T>() => (name: keyof T) => name
const nameOf = nameOfFactory<Person>();

// Why is this useful?
// Type safety! TypeScript is all about making JavaScript scale intelligently. 
// nameof is just one of the tricks in the book that makes life a little easier 
// when you want the type safety of knowing that the string you type is a 
// property on a given object.

// When declaring React components with inputs bound to the names of properties 
// on an object, you can use nameof to guarantee that the property name will 
// remain the same after you change it somewhere else:

// export const personForm = () =>
//     {<div>
//         First Name: <input name={nameOf("firstName")} />
//         Last Name: <input name={nameOf("lastName")} />
//     </div>}

// 我的理解
// 像上面的问题，Person接口可能是在一个文件中定义的，当引入文件中的这个接口的时候，
// 可能这个接口里面的很多key我是不知道的，但是有了nameof这样的函数之后，就能知道其
// 接口中key是个怎样的情况，所以在<input name={nameof("firstName")} />中，
// 这个input的key和接口中的key对应起来，只要有哪一个修改了就会报错。 

// 如果是在js中，我们经常碰见的一个问题就是比如我们将前端输入的一个变量名修改了,
// <input name={changedName} /> 这个变量将会放在一个对象里面去，假定这个对象是obj
// 但是代码中我们还是提取之前的firstName，obj["firstName"] 将会提取出一个undefined的值
// 而这个问题一般是什么时候才会发现呢，是你js代码运行的时候才会发现问题，
// 如果是在ts中利用nameof函数这个问题就会在你修改firstName到changedName的时候编译器就会报错了.
// 类型安全一个好处就是，在代码没有运行之前，就能检测到一般的错误。