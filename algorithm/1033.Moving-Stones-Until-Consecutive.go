package main

import (
	"fmt"
	"sort"
)

func main() {
	fmt.Println(numMovesStones(1, 2, 5))
	fmt.Println(numMovesStones(1, 3, 3))
}

func numMovesStones(a int, b int, c int) []int {
	tmp := []int{a, b, c}
	sort.Ints(tmp)
	max := tmp[1] - tmp[0] - 1 + tmp[2] - tmp[1] - 1
	min := 0
	if tmp[1]-tmp[0] == 1 && tmp[2]-tmp[1] == 1 {
		min = 0
	} else if tmp[1]-tmp[0] == 1 || tmp[2]-tmp[1] == 1 || tmp[1]-tmp[0] == 2 || tmp[2]-tmp[1] == 2 {
		min = 1
	} else {
		min = 2
	}
	return []int{min, max}
}
