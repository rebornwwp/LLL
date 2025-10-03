package main

import "fmt"

// A struct is a collection of fields.
// Struct fields are accessed using a dot.
// Struct fields can be accessed through a struct pointer.

// Vertex contains x and y
type Vertex struct {
	X int
	Y int
}

func main() {
	fmt.Println(Vertex{1, 2})
	v := Vertex{1, 2}
	v.X = 10
	fmt.Println(v.X, v.Y)
	p := &v
	p.X = 10 // 两种写法都行，但是这种写法简单明了
	(*p).X = 1e6
	fmt.Println(v)
}
