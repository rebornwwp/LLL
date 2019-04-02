/*
 * @lc app=leetcode id=213 lang=golang
 *
 * [213] House Robber II
 *
 * https://leetcode.com/problems/house-robber-ii/description/
 *
 * algorithms
 * Medium (35.15%)
 * Total Accepted:    109.7K
 * Total Submissions: 312.2K
 * Testcase Example:  '[2,3,2]'
 *
 * You are a professional robber planning to rob houses along a street. Each
 * house has a certain amount of money stashed. All houses at this place are
 * arranged in a circle. That means the first house is the neighbor of the last
 * one. Meanwhile, adjacent houses have security system connected and it will
 * automatically contact the police if two adjacent houses were broken into on
 * the same night.
 *
 * Given a list of non-negative integers representing the amount of money of
 * each house, determine the maximum amount of money you can rob tonight
 * without alerting the police.
 *
 * Example 1:
 *
 *
 * Input: [2,3,2]
 * Output: 3
 * Explanation: You cannot rob house 1 (money = 2) and then rob house 3 (money
 * = 2),
 * because they are adjacent houses.
 *
 *
 * Example 2:
 *
 *
 * Input: [1,2,3,1]
 * Output: 4
 * Explanation: Rob house 1 (money = 1) and then rob house 3 (money =
 * 3).
 * Total amount you can rob = 1 + 3 = 4.
 *
 */
package main

func rob(nums []int) int {
	length := len(nums)
	if nums == nil || length == 0 {
		return 0
	} else if length == 1 {
		return nums[0]
	} else if length == 2 {
		return max(nums[0], nums[1])
	}
	a1 := helper(nums, 0)
	a2 := helper(nums, 1)
	return max(a1, a2)
}

func helper(nums []int, start int) int {
	length := len(nums)
	dp := [2]int{}
	dp[0] = nums[start]
	dp[1] = max(nums[start], nums[start+1])

	for i := range nums {
		if i >= 2 && i <= length-2 {
			dp[i%2] = max(dp[(i-2)%2]+nums[i+start], dp[(i-1)%2])
		}
	}
	return dp[(length-2)%2]
}

func max(a, b int) int {
	if a >= b {
		return a
	}
	return b
}

// func main() {
// 	fmt.Println(rob([]int{2, 3, 2}))
// 	fmt.Println(rob([]int{2, 7, 9, 3, 1}))
// }
