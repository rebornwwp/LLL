/*
 * @lc app=leetcode id=377 lang=golang
 *
 * [377] Combination Sum IV
 *
 * https://leetcode.com/problems/combination-sum-iv/description/
 *
 * algorithms
 * Medium (43.69%)
 * Total Accepted:    81.4K
 * Total Submissions: 186.2K
 * Testcase Example:  '[1,2,3]\n4'
 *
 * Given an integer array with all positive numbers and no duplicates, find the
 * number of possible combinations that add up to a positive integer target.
 *
 * Example:
 *
 *
 * nums = [1, 2, 3]
 * target = 4
 *
 * The possible combination ways are:
 * (1, 1, 1, 1)
 * (1, 1, 2)
 * (1, 2, 1)
 * (1, 3)
 * (2, 1, 1)
 * (2, 2)
 * (3, 1)
 *
 * Note that different sequences are counted as different combinations.
 *
 * Therefore the output is 7.
 *
 *
 *
 *
 * Follow up:
 * What if negative numbers are allowed in the given array?
 * How does it change the problem?
 * What limitation we need to add to the question to allow negative numbers?
 *
 * Credits:
 * Special thanks to @pbrother for adding this problem and creating all test
 * cases.
 *
 */

package main

import "fmt"

func main() {
	fmt.Println(combinationSum41([]int{1, 2, 3}, 4))
}
func combinationSum41(nums []int, target int) int {
	dp := make([]int, target+1)
	dp[0] = 1
	for i := 1; i <= target; i++ {
		for j := 0; j < len(nums); j++ {
			if i-nums[j] >= 0 {
				dp[i] += dp[i-nums[j]]
			}
		}
	}
	return dp[target]
}
func combinationSum4(nums []int, target int) int {
	dp := make(map[int]int)
	return dfs(nums, target, dp)
}

func dfs(nums []int, target int, dp map[int]int) int {
	if target == 0 {
		return 1
	}
	if target < 0 {
		return 0
	}
	if val, ok := dp[target]; ok {
		return val
	}
	ans := 0
	for i := range nums {
		ans += dfs(nums, target-nums[i], dp)
	}
	dp[target] = ans
	return ans
}
