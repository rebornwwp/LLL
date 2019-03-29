package main

import "fmt"

type Vertex struct {
	X, Y float64
}

// you might notice that functions with a pointer argument must take a pointer:
// var v Vertex
// ScaleFunc(v, 5)  // Compile error!
// ScaleFunc(&v, 5) // OK
// while methods with pointer receivers take either a value or a pointer as the receiver when they are called:
// var v Vertex
// v.Scale(5)  // OK
// p := &v
// p.Scale(10) // OK

func (v *Vertex) Scale(f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}

func ScaleFunc(v *Vertex, f float64) {
	v.X = v.X * f
	v.Y = v.Y * f
}

func main() {
	v := Vertex{3, 4}
	v.Scale(2)
	ScaleFunc(&v, 10)

	p := &Vertex{4, 3}
	p.Scale(3)
	ScaleFunc(p, 8)

	fmt.Println(v, p)
}
