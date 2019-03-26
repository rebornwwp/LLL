package main

import (
	"fmt"
	"math"
)

func pow(x, n, lim float64) float64 {
	if v := math.Pow(x, n); v < lim {
		return v
	} else {
		fmt.Printf("%g -> %g\n", v, lim)
	}
	// can't use v 这里的时候应该是v的作用域没有了
	return lim
}

func main() {
	fmt.Println(
		pow(3, 2, 10),
		pow(3, 2, 20),
	)
}
