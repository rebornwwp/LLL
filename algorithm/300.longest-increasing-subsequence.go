/*
 * @lc app=leetcode id=300 lang=golang
 *
 * [300] Longest Increasing Subsequence
 *
 * https://leetcode.com/problems/longest-increasing-subsequence/description/
 *
 * algorithms
 * Medium (40.41%)
 * Total Accepted:    206.3K
 * Total Submissions: 510.4K
 * Testcase Example:  '[10,9,2,5,3,7,101,18]'
 *
 * Given an unsorted array of integers, find the length of longest increasing
 * subsequence.
 *
 * Example:
 *
 *
 * Input: [10,9,2,5,3,7,101,18]
 * Output: 4
 * Explanation: The longest increasing subsequence is [2,3,7,101], therefore
 * the length is 4.
 *
 * Note:
 *
 *
 * There may be more than one LIS combination, it is only necessary for you to
 * return the length.
 * Your algorithm should run in O(n^2) complexity.
 *
 *
 * Follow up: Could you improve it to O(n log n) time complexity?
 *
 */

package main

func lengthOfLIS2(nums []int) int {
	dp := make([]int, len(nums))
	ans := 0
	for i := range nums {
		dp[i] = 1
		ans = maxInt(dp[i], ans)
		for j := 0; j < i; j++ {
			if nums[j] < nums[i] {
				dp[i] = maxInt(dp[i], dp[j]+1)
				ans = maxInt(dp[i], ans)
			}
		}
	}
	return ans
}

func lengthOfLIS1(nums []int) int {
	if nums == nil || len(nums) == 0 {
		return 0
	}
	maxNums, minNums := max(nums)
	for i := range nums {
		nums[i] = nums[i] - minNums
	}
	dp := make([]int, maxNums-minNums+1)
	ans := 0
	for i := range nums {
		if dp[nums[i]] == 0 {
			dp[nums[i]] = 1
			ans = maxInt(ans, 1)
		}
		for j := range dp {
			if nums[i] > j {
				dp[nums[i]] = maxInt(dp[nums[i]], dp[j]+1)
				ans = maxInt(ans, dp[nums[i]])
			}
		}
	}
	return ans
}

func max(nums []int) (int, int) {
	minAns, maxAns := nums[0], nums[0]
	for i := range nums {
		if maxAns < nums[i] {
			maxAns = nums[i]
		} else if minAns > nums[i] {
			minAns = nums[i]
		}
	}
	return maxAns, minAns
}

func maxInt(a, b int) int {
	if a > b {
		return a
	}
	return b
}

// func main() {
// 	l := []int{0}
// 	fmt.Println(lengthOfLIS(l))
// }
