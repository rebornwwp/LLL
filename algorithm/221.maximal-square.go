/*
 * @lc app=leetcode id=221 lang=golang
 *
 * [221] Maximal Square
 *
 * https://leetcode.com/problems/maximal-square/description/
 *
 * algorithms
 * Medium (32.46%)
 * Total Accepted:    122.6K
 * Total Submissions: 377.1K
 * Testcase Example:  '[["1","0","1","0","0"],["1","0","1","1","1"],["1","1","1","1","1"],["1","0","0","1","0"]]'
 *
 * Given a 2D binary matrix filled with 0's and 1's, find the largest square
 * containing only 1's and return its area.
 *
 * Example:
 *
 *
 * Input:
 *
 * 1 0 1 0 0
 * 1 0 1 1 1
 * 1 1 1 1 1
 * 1 0 0 1 0
 *
 * Output: 4
 *
 */
package main

import (
	"fmt"
	"math"
)

func maximalSquare(matrix [][]byte) int {
	if matrix == nil || len(matrix) == 0 {
		return 0
	}
	dp := make([][]int, len(matrix)+1)
	for i := range dp {
		dp[i] = make([]int, len(matrix[0])+1)
	}
	ans := 0
	for i := 1; i < len(dp); i++ {
		for j := 1; j < len(dp[0]); j++ {
			if matrix[i-1][j-1] == '1' {
				temp := min(min(dp[i-1][j], dp[i-1][j-1]), dp[i][j-1])
				dp[i][j] = (int(math.Sqrt(float64(temp))) + 1) * (int(math.Sqrt(float64(temp))) + 1)
				if ans < dp[i][j] {
					ans = dp[i][j]
				}
			} else {
				dp[i][j] = 0
			}
		}
	}
	for i := range dp {
		fmt.Println(dp[i])
	}
	return ans
}

func min(a, b int) int {
	if a > b {
		return b
	}
	return a
}

// func main() {
// 	l := [][]byte{[]byte{'1', '1', '1', '1', '1'}, []byte{'1', '1', '1', '1', '1'}, []byte{'1', '1', '1', '1', '1'}}
// 	for i := range l {
// 		fmt.Println(l[i])
// 	}
// 	fmt.Println(len(l[0]))
// 	fmt.Println(maximalSquare(l))
// }
