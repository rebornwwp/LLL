/*
 * @lc app=leetcode id=34 lang=golang
 *
 * [34] Find First and Last Position of Element in Sorted Array
 */
package main

// func main() {
// 	l := []int{1, 2, 3, 4, 4, 4, 4, 6}
// 	fmt.Println(searchRange(l, 5))
// }
func searchRange(nums []int, target int) []int {
	start := -1
	end := -1

	i := 0
	j := len(nums)
	for i < j {
		mid := (i + j) / 2
		if (mid == 0 || nums[mid] != nums[mid-1]) && nums[mid] == target {
			start = mid
			break
		} else if nums[mid] < target {
			i = mid + 1
		} else if nums[mid] >= target {
			j = mid
		}
	}
	i = 0
	j = len(nums)
	for i < j {
		mid := (i + j) / 2
		if (mid == len(nums)-1 || nums[mid] != nums[mid+1]) && nums[mid] == target {
			end = mid
			break
		} else if nums[mid] <= target {
			i = mid + 1
		} else if nums[mid] > target {
			j = mid
		}
	}
	return []int{start, end}
}
