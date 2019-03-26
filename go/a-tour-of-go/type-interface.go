package main

import "fmt"

func main() {
	var i int
	i = 12
	fmt.Printf("v is of type %T\n", i)
	var j = 12
	fmt.Printf("v is of type %T\n", j)
	k := 1.23
	fmt.Printf("v is of type %T\n", k)
	w := 0.123 + 1.2i
	fmt.Printf("v is of type %T\n", w)
	fmt.Printf("v is of type %T\n", 2)
}

