/*
 * @lc app=leetcode id=219 lang=golang
 *
 * [219] Contains Duplicate II
 *
 * https://leetcode.com/problems/contains-duplicate-ii/description/
 *
 * algorithms
 * Easy (35.00%)
 * Total Accepted:    190.6K
 * Total Submissions: 544.5K
 * Testcase Example:  '[1,2,3,1]\n3'
 *
 * Given an array of integers and an integer k, find out whether there are two
 * distinct indices i and j in the array such that nums[i] = nums[j] and the
 * absolute difference between i and j is at most k.
 *
 *
 * Example 1:
 *
 *
 * Input: nums = [1,2,3,1], k = 3
 * Output: true
 *
 *
 *
 * Example 2:
 *
 *
 * Input: nums = [1,0,1,1], k = 1
 * Output: true
 *
 *
 *
 * Example 3:
 *
 *
 * Input: nums = [1,2,3,1,2,3], k = 2
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
	m := []int{1, 2, 1}
	fmt.Println(containsNearbyDuplicate(m, 2))
}

func containsNearbyDuplicate(nums []int, k int) bool {
	m := make(map[int]int)
	for i, v := range nums {
		if val, ok := m[v]; ok {
			if i-val <= k {
				return true
			}
		}
		m[v] = i
	}
	return false
}
