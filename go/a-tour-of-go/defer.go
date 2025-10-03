package main

import "fmt"

// The deferred call's arguments are evaluated immediately,
// but the function call is not executed until the surrounding function returns.
// 看了下pingcap的代码片段, 将一些之后结束要运行的代码，提前先写上
// se, err := session.CreateSession4Test(s.store)
// c.Check(err, IsNil)
// defer se.Close()

func main() {
	defer fmt.Println("world")
	i := 10
	fmt.Println("hello")
	fmt.Println(i)
}
