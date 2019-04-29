package main

import (
	"fmt"
	"math"
)

func main() {
	blocked := [][]int{[]int{0, 1}, []int{1, 0}}
	fmt.Println(isEscapePossible(blocked, []int{0, 0}, []int{0, 2}))
}

func isEscapePossible(blocked [][]int, source []int, target []int) bool {
	blockedSet := make(map[[2]int]bool)
	for i := range blocked {
		key := formatSlice(blocked[i])
		blockedSet[key] = true
	}

	var bfs func([2]int, [2]int) bool
	bfs = func(source [2]int, target [2]int) bool {
		moves := [][]int{[]int{1, 0}, []int{-1, 0}, []int{0, 1}, []int{0, -1}}
		var q [][2]int
		q = append(q, source)
		visited := make(map[[2]int]bool)

		level := 0
		for len(q) > 0 {
			for range q {
				first := q[0]
				q = q[1:]
				if first[0] == target[0] && first[1] == target[1] {
					return true
				}

				for i := range moves {
					xs := first[0] + moves[i][0]
					ys := first[1] + moves[i][1]
					point := [2]int{xs, ys}
					_, ok1 := visited[point]
					_, ok2 := blockedSet[point]
					if xs >= 0 && xs <= int(math.Pow10(6)) && ys >= 0 && ys <= int(math.Pow10(6)) && !ok1 && !ok2 {
						visited[point] = true
						q = append(q, point)
					}
				}
			}
			level += 1
			if level >= len(blockedSet) {
				return true
			}
		}
		return false
	}
	a := formatSlice(source)
	b := formatSlice(target)
	return bfs(a, b) && bfs(b, a)
}

func formatSlice(a []int) [2]int {
	return [2]int{a[0], a[1]}
}
