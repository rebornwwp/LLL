/*
 * @lc app=leetcode id=63 lang=golang
 *
 * [63] Unique Paths II
 *
 * https://leetcode.com/problems/unique-paths-ii/description/
 *
 * algorithms
 * Medium (33.28%)
 * Total Accepted:    189.9K
 * Total Submissions: 570.5K
 * Testcase Example:  '[[0,0,0],[0,1,0],[0,0,0]]'
 *
 * A robot is located at the top-left corner of a m x n grid (marked 'Start' in
 * the diagram below).
 *
 * The robot can only move either down or right at any point in time. The robot
 * is trying to reach the bottom-right corner of the grid (marked 'Finish' in
 * the diagram below).
 *
 * Now consider if some obstacles are added to the grids. How many unique paths
 * would there be?
 *
 *
 *
 * An obstacle and empty space is marked as 1 and 0 respectively in the grid.
 *
 * Note: m and n will be at most 100.
 *
 * Example 1:
 *
 *
 * Input:
 * [
 * [0,0,0],
 * [0,1,0],
 * [0,0,0]
 * ]
 * Output: 2
 * Explanation:
 * There is one obstacle in the middle of the 3x3 grid above.
 * There are two ways to reach the bottom-right corner:
 * 1. Right -> Right -> Down -> Down
 * 2. Down -> Down -> Right -> Right
 *
 *
 */

package main

import "fmt"

func uniquePathsWithObstacles(obstacleGrid [][]int) int {
	if obstacleGrid == nil {
		return 0
	}
	dp := make([][]int, len(obstacleGrid)+1)
	for i := range dp {
		dp[i] = make([]int, len(obstacleGrid[0])+1)
	}
	fmt.Println(dp)

	for i := 1; i <= len(obstacleGrid); i++ {
		for j := 1; j <= len(obstacleGrid[0]); j++ {
			if obstacleGrid[i-1][j-1] == 1 {
				dp[i][j] = 0
			} else if i == 1 && j == 1 {
				dp[i][j] = 1
			} else {
				dp[i][j] = dp[i-1][j] + dp[i][j-1]
			}
		}
	}
	for i := range dp {
		fmt.Println(dp[i])
	}
	return dp[len(obstacleGrid)][len(obstacleGrid[0])]
}

// func main() {
// 	obs := [][]int{[]int{0, 1, 0}}
// 	fmt.Println(uniquePathsWithObstacles(obs))
// }
