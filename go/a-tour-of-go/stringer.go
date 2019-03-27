package main

import "fmt"

// Person struct
type Person struct {
	Name string
	Age  int
}

func (p Person) String() string {
	return fmt.Sprintf("%v, (%v years)!", p.Name, p.Age)
}

func main() {
	p1 := Person{"wang", 12}
	p2 := Person{"zhang", 123}
	fmt.Println(p1)
	fmt.Println(p2)
}
