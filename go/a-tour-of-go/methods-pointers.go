package main

import (
	"fmt"
	"math"
)

// Vertex hello
type Vertex struct {
	X, Y float64
}

// Abs hello
func (v Vertex) Abs() float64 {
	return math.Sqrt(v.X*v.X + v.Y*v.Y)
}

// Scale hello 对本身做操作
func (v *Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}

func main() {
	v := Vertex{3, 4}
	v.Scale(2.0)
	fmt.Println(v.Abs())
}
