/*
 * @lc app=leetcode id=220 lang=golang
 *
 * [220] Contains Duplicate III
 *
 * https://leetcode.com/problems/contains-duplicate-iii/description/
 *
 * algorithms
 * Medium (19.57%)
 * Total Accepted:    89K
 * Total Submissions: 454.7K
 * Testcase Example:  '[1,2,3,1]\n3\n0'
 *
 * Given an array of integers, find out whether there are two distinct indices
 * i and j in the array such that the absolute difference between nums[i] and
 * nums[j] is at most t and the absolute difference between i and j is at most
 * k.
 *
 *
 * Example 1:
 *
 *
 * Input: nums = [1,2,3,1], k = 3, t = 0
 * Output: true
 *
 *
 *
 * Example 2:
 *
 *
 * Input: nums = [1,0,1,1], k = 1, t = 2
 * Output: true
 *
 *
 *
 * Example 3:
 *
 *
 * Input: nums = [1,5,9,1,5,9], k = 2, t = 3
 * Output: false
 *
 *
 *
 *
 *
 */
package main

import "fmt"

func main() {
	m := []int{1, 5, 9, 1, 5, 9}
	fmt.Println(containsNearbyAlmostDuplicate(m, 2, 3))
}

func containsNearbyAlmostDuplicate(nums []int, k int, t int) bool {
	m := make(map[int]int)
	for i, v := range nums {
		if val, ok := m[v]; ok {
			if i-val <= k && abs(val-v) < t {
				return true
			}
		}
		m[v] = i
	}
	return false
}

func abs(a int) int {
	if a < 0 {
		return -a
	}
	return a
}
