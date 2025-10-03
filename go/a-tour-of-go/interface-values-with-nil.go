package main

import "fmt"

// I interface
type I interface {
	M()
}

// T struct
type T struct {
	S string
}

// M method
func (t *T) M() {
	if t == nil {
		fmt.Println("<nil>")
		return
	}
	fmt.Println(t.S)
}

func main() {
	var i I
	var t *T
	i = t
	describe(i)
	i.M()

	i = &T{"hello"}
	describe(i)
	i.M()

}

func describe(i I) {
	fmt.Printf("(%v, %T)\n", i, i)
}
