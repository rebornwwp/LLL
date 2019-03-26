package main

import "fmt"

func main() {
	sum := 0
	for i := 0; i < 10; i++ {
		sum += i
	}
	fmt.Println(sum)

	sum1 := 1
	// init and post are optional
	for ; sum1 < 1000; {
		sum1 += sum1
		fmt.Println(sum1)
	}
	fmt.Println(sum1)
}

