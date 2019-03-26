package main

import "fmt"

func main() {
	ans := "answer"
	m := make(map[string]int)
	m[ans] = 42
	fmt.Println("the value:", m[ans])
	m[ans] = 48
	delete(m, ans)
	fmt.Println("the value:", m[ans])
	v, ok := m[ans]
	fmt.Println("the value:", v, "Present?", ok)
}
