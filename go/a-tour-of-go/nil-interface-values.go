package main

import "fmt"

// A nil interface value holds neither value nor concrete type.

// I interface
type I interface {
	M()
}

func main() {
	var i I
	describe(i)
}

func describe(i I) {
	fmt.Printf("(%v, %T)\n", i, i)
}
