/*
 * @lc app=leetcode id=217 lang=golang
 *
 * [217] Contains Duplicate
 *
 * https://leetcode.com/problems/contains-duplicate/description/
 *
 * algorithms
 * Easy (51.41%)
 * Total Accepted:    319.7K
 * Total Submissions: 621.8K
 * Testcase Example:  '[1,2,3,1]'
 *
 * Given an array of integers, find if the array contains any duplicates.
 *
 * Your function should return true if any value appears at least twice in the
 * array, and it should return false if every element is distinct.
 *
 * Example 1:
 *
 *
 * Input: [1,2,3,1]
 * Output: true
 *
 * Example 2:
 *
 *
 * Input: [1,2,3,4]
 * Output: false
 *
 * Example 3:
 *
 *
 * Input: [1,1,1,3,3,4,3,2,4,2]
 * Output: true
 *
 */

package main

// import "fmt"

// func main() {
// 	fmt.Println(containsDuplicate([]int{1, 2, 3, 1}))
// }

func containsDuplicate(nums []int) bool {
	m := make(map[int]int)
	for _, i := range nums {
		if _, ok := m[i]; ok {
			m[i] += 1
		} else {
			m[i] = 1
		}
		if m[i] > 1 {
			return true
		}
	}
	return false
}
