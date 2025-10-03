package main

import "fmt"

func do(i interface{}) {
	switch v := i.(type) {
	case int:
		fmt.Println(v)
	case string:
		fmt.Println(v)
	default:
		fmt.Println("I don't know about type %T\n", v)
	}
}

func main() {
	do(2)
	do("hello")
	do(true)
	do(1231231273627846278)
}
