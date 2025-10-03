package main

import "fmt"

func main() {
	i, j := 42, 2701
	p := &i         // p point to i
	fmt.Println(*p) // read i through the pointer p
	*p = 21         //set i through the pointer
	fmt.Println(i)  // see the new value of i

	pp := &j       // pointer to j
	*pp = *pp / 37 //divide j through the pointer
	fmt.Println(j) // see the new value of j
}
