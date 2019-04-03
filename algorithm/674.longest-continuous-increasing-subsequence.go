/*
 * @lc app=leetcode id=674 lang=golang
 *
 * [674] Longest Continuous Increasing Subsequence
 *
 * https://leetcode.com/problems/longest-continuous-increasing-subsequence/description/
 *
 * algorithms
 * Easy (43.96%)
 * Total Accepted:    61.8K
 * Total Submissions: 140.7K
 * Testcase Example:  '[1,3,5,4,7]'
 *
 *
 * Given an unsorted array of integers, find the length of longest continuous
 * increasing subsequence (subarray).
 *
 *
 * Example 1:
 *
 * Input: [1,3,5,4,7]
 * Output: 3
 * Explanation: The longest continuous increasing subsequence is [1,3,5], its
 * length is 3.
 * Even though [1,3,5,7] is also an increasing subsequence, it's not a
 * continuous one where 5 and 7 are separated by 4.
 *
 *
 *
 * Example 2:
 *
 * Input: [2,2,2,2,2]
 * Output: 1
 * Explanation: The longest continuous increasing subsequence is [2], its
 * length is 1.
 *
 *
 *
 * Note:
 * Length of the array will not exceed 10,000.
 *
 */
package main

func findLengthOfLCIS(nums []int) int {
	start := -1
	ans := 0
	for i := 0; i < len(nums); i++ {
		if i == len(nums)-1 {
			ans = maxInt(ans, i-start)
		} else if nums[i] >= nums[i+1] {
			ans = maxInt(ans, i-start)
			start = i
		}
	}
	return ans
}

func maxInt(a, b int) int {
	if a > b {
		return a
	}
	return b
}

// func main() {
// 	l := []int{2, 2, 2, 2, 3, 4, 5}
// 	fmt.Println(findLengthOfLCIS(l))
// }
