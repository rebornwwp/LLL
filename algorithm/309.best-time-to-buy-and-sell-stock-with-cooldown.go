/*
 * @lc app=leetcode id=309 lang=golang
 *
 * [309] Best Time to Buy and Sell Stock with Cooldown
 *
 * https://leetcode.com/problems/best-time-to-buy-and-sell-stock-with-cooldown/description/
 *
 * algorithms
 * Medium (43.62%)
 * Total Accepted:    85.8K
 * Total Submissions: 196.6K
 * Testcase Example:  '[1,2,3,0,2]'
 *
 * Say you have an array for which the i^th element is the price of a given
 * stock on day i.
 *
 * Design an algorithm to find the maximum profit. You may complete as many
 * transactions as you like (ie, buy one and sell one share of the stock
 * multiple times) with the following restrictions:
 *
 *
 * You may not engage in multiple transactions at the same time (ie, you must
 * sell the stock before you buy again).
 * After you sell your stock, you cannot buy stock on next day. (ie, cooldown 1
 * day)
 *
 *
 * Example:
 *
 *
 * Input: [1,2,3,0,2]
 * Output: 3
 * Explanation: transactions = [buy, sell, cooldown, buy, sell]
 *
 */
package main

import "fmt"

func main() {
	prices := []int{2, 1, 4}
	fmt.Println(maxProfit(prices))
}
func maxProfit(prices []int) int {
	dp := make([][]int, len(prices))
	for i := range dp {
		dp[i] = make([]int, len(prices))
	}
	ans := helper(prices, 0, len(prices)-1, dp)
	return ans
}

func helper(prices []int, begin int, end int, dp [][]int) int {
	if begin >= end {
		return 0
	}
	if dp[begin][end] > 0 {
		return dp[begin][end]
	}
	isDesc := true
	for i := begin; i < end; i++ {
		isDesc = isDesc && (prices[i] >= prices[i+1])
	}
	ans := 0
	if !isDesc {
		ans = max(ans, prices[end]-prices[begin])
		for i := begin; i <= end; i++ {
			ans = max(ans, helper(prices, begin, i-1, dp)+helper(prices, i+1, end, dp))
		}
	}
	dp[begin][end] = ans
	return ans
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
