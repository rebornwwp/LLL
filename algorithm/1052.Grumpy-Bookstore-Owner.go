package main

import "fmt"

// Today, the bookstore owner has a store open for customers.length minutes.  Every minute, some number of customers (customers[i]) enter the store, and all those customers leave after the end of that minute.
//
// On some minutes, the bookstore owner is grumpy.  If the bookstore owner is grumpy on the i-th minute, grumpy[i] = 1, otherwise grumpy[i] = 0.  When the bookstore owner is grumpy, the customers of that minute are not satisfied, otherwise they are satisfied.
//
// The bookstore owner knows a secret technique to keep themselves not grumpy for X minutes straight, but can only use it once.
//
// Return the maximum number of customers that can be satisfied throughout the day.
//
//
//
// Example 1:
//
// Input: customers = [1,0,1,2,1,1,7,5], grumpy = [0,1,0,1,0,1,0,1], X = 3
// Output: 16
// Explanation: The bookstore owner keeps themselves not grumpy for the last 3 minutes.
// The maximum number of customers that can be satisfied = 1 + 1 + 1 + 1 + 7 + 5 = 16.
//
//
// Note:
//
// 1 <= X <= customers.length == grumpy.length <= 20000
// 0 <= customers[i] <= 1000
// 0 <= grumpy[i] <= 1

func main() {
	customers := []int{1, 0, 1, 2, 1, 1, 7, 5}
	grumpy := []int{0, 1, 0, 1, 0, 1, 0, 1}
	X := 3
	fmt.Println(maxSatisfied(customers, grumpy, X))
}

func maxSatisfied(customers []int, grumpy []int, X int) int {
	ng := 0
	g := 0
	add_g := 0
	for i, value := range grumpy {
		if value == 1 {
			g += customers[i]
		} else {
			ng += customers[i]
		}
		if i >= X && grumpy[i-X] == 1 {
			g -= customers[i-X]
		}
		add_g = max(add_g, g)
	}
	fmt.Println(ng, add_g)
	return ng + add_g
}

func max(x ...int) int {
	a := x[0]
	for _, n := range x {
		if n > a {
			a = n
		}
	}
	return a
}
