package main

import (
	"fmt"
	"math"
)

func pow(x, n, lim float64) float64 {
	if v:= math.Pow(x, n); v < lim {
		return v
	}
	return lim
}

func main() {
	fmt.Println(
		pow(3, 2, 10),
		pow(3, 2, 20))
	fmt.Println(
		pow(3, 2, 10),
		pow(3, 2, 20), // 这个都好必须写 编译器报错syntax error: unexpected newline, expecting comma or ) 这里编译器说需要加一个逗号或者右括号
	)
}

