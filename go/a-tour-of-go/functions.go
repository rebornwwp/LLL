package main

import (
	"fmt"
	"math"
)

func add(x int, y int) int {
	return (x + y) * int(math.Sqrt(16))
}

// x int, y int ===> x, y int
func add1(x, y int) int {
	return (x + y) * int(math.Sqrt(16))
}

func main() {
	fmt.Println(add(4, 5))
	fmt.Println(add1(4, 5))
}
