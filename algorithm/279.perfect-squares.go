/*
 * @lc app=leetcode id=279 lang=golang
 *
 * [279] Perfect Squares
 *
 * https://leetcode.com/problems/perfect-squares/description/
 *
 * algorithms
 * Medium (41.20%)
 * Total Accepted:    171.4K
 * Total Submissions: 414.6K
 * Testcase Example:  '12'
 *
 * Given a positive integer n, find the least number of perfect square numbers
 * (for example, 1, 4, 9, 16, ...) which sum to n.
 *
 * Example 1:
 *
 *
 * Input: n = 12
 * Output: 3
 * Explanation: 12 = 4 + 4 + 4.
 *
 * Example 2:
 *
 *
 * Input: n = 13
 * Output: 2
 * Explanation: 13 = 4 + 9.
 */

package main

import "fmt"

func main() {
	fmt.Println(numSquares1(7168))
}

// time limit exceeded
func numSquares1(n int) int {
	l := []int{}
	for i := 1; i*i <= n; i++ {
		l = append([]int{i * i}, l...)
	}
	return dfs(l, 0, n)
}

func dfs(l []int, ans int, n int) int {
	if n == 0 {
		return ans
	}
	count := 1<<31 - 1
	var quotient, reminder int
	for i := range l {
		quotient = int(n / l[i])
		reminder = n % l[i]
		count = min(count, dfs(l[i+1:len(l)], ans+quotient, reminder))
	}
	return count
}

func numSquares(n int) int {
	l := []int{}
	for i := 1; i*i <= n; i++ {
		l = append(l, i*i)
	}
	return helper(l, n)
}

func helper(l []int, n int) int {
	m := 1<<31 - 1
	dp := make([][]int, len(l)+1)
	for i := range dp {
		dp[i] = make([]int, n+1)
		for j := range dp[i] {
			dp[i][j] = m
		}
		dp[i][0] = 0
	}
	var item int
	for i := 1; i <= len(l); i++ {
		for j := 1; j <= n; j++ {
			dp[i][j] = dp[i-1][j]
			item = int(j/l[i-1]) + 1
			for k := 1; k < item; k++ {
				if j-k*l[i-1] >= 0 {
					dp[i][j] = min(dp[i-1][j], dp[i-1][j-k*l[i-1]]+k)
				}
			}
		}
	}
	return dp[len(l)][n]
}
func min(a, b int) int {
	if a > b {
		return b
	}
	return a
}
