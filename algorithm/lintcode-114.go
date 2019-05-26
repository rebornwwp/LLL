package main

import "fmt"

// 描述
// 中文
// English
// 有一个机器人的位于一个 m × n 个网格左上角。
//
// 机器人每一时刻只能向下或者向右移动一步。机器人试图达到网格的右下角。
//
// 问有多少条不同的路径？
//
// n和m均不超过100
//
// 您在真实的面试中是否遇到过这个题？
// 样例
// Example 1:
//
// Input: n = 1, m = 3
// Output: 1
// Explanation: Only one path to target position.
// Example 2:
//
// Input:  n = 3, m = 3
// Output: 6
// Explanation:
// D : Down
// R : Right
// 1) DDRR
// 2) DRDR
// 3) DRRD
// 4) RRDD
// 5) RDRD
// 6) RDDR

func main() {
	m := 3
	n := 1
	fmt.Println(uniquePaths(m, n))
}

/**
 * @param m: positive integer (1 <= m <= 100)
 * @param n: positive integer (1 <= n <= 100)
 * @return: An integer
 */
func uniquePaths(m int, n int) int {
	dp := make([][]int, m+1)
	for i := range dp {
		dp[i] = make([]int, n+1)
	}

	dp[1][0] = 1
	for i := 1; i < m+1; i++ {
		for j := 1; j < n+1; j++ {
			dp[i][j] = dp[i-1][j] + dp[i][j-1]
		}
	}
	return dp[m][n]
}
