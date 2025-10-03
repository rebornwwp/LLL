/*
 * @lc app=leetcode id=60 lang=golang
 *
 * [60] Permutation Sequence
 */
package main

import (
	"strconv"
)

// func main() {
// 	fmt.Println(getPermutation(4, 9))
// }

func getPermutation(n int, k int) string {
	tmp := factor(n)
	ans := ""
	numbers := make([]string, 0)
	for i := 0; i < n; i++ {
		numbers = append(numbers, strconv.Itoa(i+1))
	}
	k--
	for len(numbers) > 0 {
		tmp = tmp / n
		n--
		a := int(k / tmp)
		k = k % tmp
		ans += numbers[a]
		numbers = append(numbers[0:a], numbers[a+1:len(numbers)]...)
	}
	return ans
}

func factor(n int) int {
	ans := 1
	for n > 0 {
		ans = ans * n
		n--
	}
	return ans
}
