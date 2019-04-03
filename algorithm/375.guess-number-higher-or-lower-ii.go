/*
 * @lc app=leetcode id=375 lang=golang
 *
 * [375] Guess Number Higher or Lower II
 *
 * https://leetcode.com/problems/guess-number-higher-or-lower-ii/description/
 *
 * algorithms
 * Medium (37.35%)
 * Total Accepted:    42.2K
 * Total Submissions: 112.8K
 * Testcase Example:  '1'
 *
 * We are playing the Guess Game. The game is as follows:
 *
 * I pick a number from 1 to n. You have to guess which number I picked.
 *
 * Every time you guess wrong, I'll tell you whether the number I picked is
 * higher or lower.
 *
 * However, when you guess a particular number x, and you guess wrong, you pay
 * $x. You win the game when you guess the number I picked.
 *
 * Example:
 *
 *
 * n = 10, I pick 8.
 *
 * First round:  You guess 5, I tell you that it's higher. You pay $5.
 * Second round: You guess 7, I tell you that it's higher. You pay $7.
 * Third round:  You guess 9, I tell you that it's lower. You pay $9.
 *
 * Game over. 8 is the number I picked.
 *
 * You end up paying $5 + $7 + $9 = $21.
 *
 *
 * Given a particular n ≥ 1, find out how much money you need to have to
 * guarantee a win.
 */

package main

import (
	"fmt"
	"math"
)

func getMoneyAmount(n int) int {
	dp := make([][]int, n)
	for i := range dp {
		dp[i] = make([]int, n)
	}
	ans := getMinCost(0, n-1, dp)
	for i := range dp {
		fmt.Println(dp[i])
	}
	return ans
}

func getMinCost(start int, end int, dp [][]int) int {
	if start >= end {
		return 0
	}
	if dp[start][end] != 0 {
		return dp[start][end]
	}
	minCost := math.MaxInt16
	for i := start; i < end; i++ {
		minCost = min(minCost, (i+1)+max(getMinCost(start, i-1, dp), getMinCost(i+1, end, dp)))
	}
	dp[start][end] = minCost
	return dp[start][end]
}

func min(a, b int) int {
	if a > b {
		return b
	}
	return a
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func main() {
	fmt.Println(getMoneyAmount(12))
}
