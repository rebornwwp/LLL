/*
 * @lc app=leetcode id=62 lang=golang
 *
 * [62] Unique Paths
 *
 * https://leetcode.com/problems/unique-paths/description/
 *
 * algorithms
 * Medium (46.86%)
 * Total Accepted:    270.9K
 * Total Submissions: 578K
 * Testcase Example:  '3\n2'
 *
 * A robot is located at the top-left corner of a m x n grid (marked 'Start' in
 * the diagram below).
 *
 * The robot can only move either down or right at any point in time. The robot
 * is trying to reach the bottom-right corner of the grid (marked 'Finish' in
 * the diagram below).
 *
 * How many possible unique paths are there?
 *
 *
 * Above is a 7 x 3 grid. How many possible unique paths are there?
 *
 * Note: m and n will be at most 100.
 *
 * Example 1:
 *
 *
 * Input: m = 3, n = 2
 * Output: 3
 * Explanation:
 * From the top-left corner, there are a total of 3 ways to reach the
 * bottom-right corner:
 * 1. Right -> Right -> Down
 * 2. Right -> Down -> Right
 * 3. Down -> Right -> Right
 *
 *
 * Example 2:
 *
 *
 * Input: m = 7, n = 3
 * Output: 28
 *
 */
package main

import "fmt"

func uniquePaths(m, n int) int {
	if m < 1 || n < 1 {
		return 0
	}
	if m == 1 && n > 1 {
		return 1
	}
	if m > 1 && n == 1 {
		return 1
	}
	dp := make([]int, n)
	for i := range dp {
		dp[i] = 1
	}
	for i := 1; i < m; i++ {
		for j := 1; j < n; j++ {
			fmt.Println(dp)
			dp[j] += dp[j-1]
		}
	}
	return dp[n-1]
}
func uniquePaths1(m int, n int) int {
	if m < 1 || n < 1 {
		return 0
	}
	if m == 1 && n > 1 {
		return 1
	}
	if m > 1 && n == 1 {
		return 1
	}
	ans := 1
	div := 1
	small := min(m, n)
	for i := 1; i < small; i++ {
		ans *= m + n - 1 - i
		div *= i
	}
	return ans / div
}
func min(a, b int) int {
	if a > b {
		return b
	}
	return a
}

func main() {
	fmt.Println(uniquePaths(13, 23))
}
