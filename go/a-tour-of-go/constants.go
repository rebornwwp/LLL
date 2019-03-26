package main

import "fmt"

// Pi represents pi
const Pi = 3.14

func main() {
	const World = "世界"
	fmt.Println("hello ", World)
	fmt.Println(Pi)
	i := Pi
	const t = true
	// const a := true don't do that
	fmt.Printf("valur %T\n", i)
	fmt.Printf("valur %T\n", t)
}
