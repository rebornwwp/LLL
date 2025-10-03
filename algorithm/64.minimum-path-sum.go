/*
 * @lc app=leetcode id=64 lang=golang
 *
 * [64] Minimum Path Sum
 *
 * https://leetcode.com/problems/minimum-path-sum/description/
 *
 * algorithms
 * Medium (45.97%)
 * Total Accepted:    217.6K
 * Total Submissions: 472.3K
 * Testcase Example:  '[[1,3,1],[1,5,1],[4,2,1]]'
 *
 * Given a m x n grid filled with non-negative numbers, find a path from top
 * left to bottom right which minimizes the sum of all numbers along its path.
 *
 * Note: You can only move either down or right at any point in time.
 *
 * Example:
 *
 *
 * Input:
 * [
 * [1,3,1],
 * ⁠ [1,5,1],
 * ⁠ [4,2,1]
 * ]
 * Output: 7
 * Explanation: Because the path 1→3→1→1→1 minimizes the sum.
 *
 *
 */
package main

func minPathSum(grid [][]int) int {
	dp := make([]int, len(grid[0]))
	for i := range grid {
		for j := range grid[i] {
			if j == 0 {
				dp[j] = dp[j] + grid[i][j]
			} else if i == 0 && j > 0 {
				dp[j] = dp[j-1] + grid[i][j]
			} else {
				dp[j] = min(dp[j], dp[j-1]) + grid[i][j]
			}
		}
	}
	return dp[len(dp)-1]
}

func min(a, b int) int {
	if a > b {
		return b
	}
	return a
}

// func main() {
// 	l := [][]int{[]int{1}, []int{1}, []int{4}}
// 	fmt.Println(minPathSum(l))
// }
