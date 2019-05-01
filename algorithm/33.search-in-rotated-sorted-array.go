/*
 * @lc app=leetcode id=33 lang=golang
 *
 * [33] Search in Rotated Sorted Array
 */

package main

import "fmt"

// func main() {
// 	l := []int{5, 1, 3}
// 	fmt.Println(search(l, 3))
// }

func search(nums []int, target int) int {
	i := 0
	j := len(nums) - 1
	for i <= j {
		mid := (i + j) / 2
		if nums[mid] == target {
			return mid
		}

		if nums[i] <= nums[mid] {
			if nums[i] <= target && target < nums[mid] {
				j = mid - 1
			} else {
				i = mid + 1
			}
		} else {
			if nums[mid] <= target && target <= nums[j] {
				i = mid + 1
			} else {
				j = mid - 1
			}
		}
		fmt.Println(i, j)
	}
	return -1
}
