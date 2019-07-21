package main

// Given an unsorted array of integers, find the length of the longest consecutive elements sequence.
//
// Your algorithm should run in O(n) complexity.
//
// Example:
//
// Input: [100, 4, 200, 1, 3, 2]
// Output: 4
// Explanation: The longest consecutive elements sequence is [1, 2, 3, 4]. Therefore its length is 4.

import (
	"fmt"
)

func main() {
	nums := []int{100, 4, 200, 1, 3, 2}
	fmt.Println(longestConsecutive(nums))
}

func longestConsecutive(nums []int) int {
	m := make(map[int]bool)

	for _, num := range nums {
		m[num] = true
	}

	ans := 0
	for _, num := range nums {
		if _, ok := m[num]; !ok {
			continue
		}
		delete(m, num)
		prev, next := num-1, num+1
		_, ok := m[prev]
		for ok {
			delete(m, prev)
			prev--
			_, ok = m[prev]
		}
		_, ok = m[next]
		for ok {
			delete(m, next)
			next++
			_, ok = m[next]
		}
		ans = max(ans, next-prev-1)
	}
	return ans
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
