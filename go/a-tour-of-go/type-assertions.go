package main

import "fmt"

// interface I {
//     length: number;
// }
// function geLength(num: string | number): number {
//     return (num as I).length
// }
// function geLength(num: string | number): number {
//     return (num as string).length
// }
// console.log(geLength("hello"))
// console.log(geLength(12345)
// 类型断言，和typescript中的类型差不多，as a 其中a可以是数据类型，也可以是借口
func main() {
	var i interface{} = "hello"

	s := i.(string)
	fmt.Println(s)

	s, ok := i.(string)
	fmt.Println(s, ok)

	f, ok := i.(float64)
	fmt.Println(f, ok)
	k := i.(float64) // panic
	fmt.Println(k)
}
