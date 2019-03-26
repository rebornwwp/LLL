package main

import "fmt"

func main() {
	s := []int{1, 2, 3, 4, 5, 6, 7, 8}
	fmt.Println(s)
	s = s[1:5]
	fmt.Println(s)
	s = s[:3]
	fmt.Println(s)
	s = s[1:]
	fmt.Println(s)
}
