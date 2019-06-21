package main

import (
	"fmt"
	"sort"
)

func main() {
	nums := []int{}
	fmt.Println(longestIncreasingSubsequence(nums))
	fmt.Println(longestIncreasingSubsequence1(nums))
}

/**
 * @param nums: An integer array
 * @return: The length of LIS (longest increasing subsequence)
 */
func longestIncreasingSubsequence(nums []int) int {
	dp := make([]int, len(nums))
	for i := range dp {
		dp[i] = 1
	}

	for i := 0; i < len(nums); i++ {
		for j := 0; j < i; j++ {
			if nums[j] < nums[i] {
				dp[i] = max(dp[j]+1, dp[i])
			}
		}
	}
	return max(dp...)
}

func max(a ...int) int {
	if len(a) == 0 {
		return 0
	}
	x := a[0]
	for i := range a {
		if a[i] > x {
			x = a[i]
		}
	}
	return x
}

func longestIncreasingSubsequence1(nums []int) int {
	stack := make([]int, 0)

	for _, n := range nums {
		at := sort.SearchInts(stack, n)
		if at == len(stack) {
			stack = append(stack, n)
		} else if stack[at] > n {
			stack[at] = n
		}
	}

	return len(stack)
}
