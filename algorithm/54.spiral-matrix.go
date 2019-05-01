/*
 * @lc app=leetcode id=54 lang=golang
 *
 * [54] Spiral Matrix
 */
package main

import "fmt"

func main() {
	matrix := [][]int{
		[]int{1},
		[]int{5},
		[]int{9},
		[]int{13},
	}

	fmt.Println(spiralOrder(matrix))
}
func spiralOrder(matrix [][]int) []int {
	var helper func([][]int, []int, int)
	helper = func(matrix [][]int, ans []int, index int) {
		if len(matrix) == 0 {
			return
		}
		if len(matrix) == 1 {
			for i := 0; i < len(matrix[0]); i++ {
				ans[index] = matrix[0][i]
				index++
			}
			return
		}

		for i := 0; i < len(matrix[0]); i++ {
			ans[index] = matrix[0][i]
			index++
		}
		matrix = matrix[1:len(matrix)]

		for i := 0; i < len(matrix); i++ {
			ans[index] = matrix[i][len(matrix[i])-1]
			index++
			matrix[i] = matrix[i][0 : len(matrix[i])-1]
		}
		if len(matrix) > 0 && len(matrix[0]) == 0 {
			matrix = [][]int{}
		}
		if len(matrix) > 0 {
			for i := len(matrix[0]) - 1; i >= 0; i-- {
				ans[index] = matrix[len(matrix)-1][i]
				index++
			}
			matrix = matrix[0 : len(matrix)-1]
		}
		for i := len(matrix) - 1; i >= 0; i-- {
			ans[index] = matrix[i][0]
			index++
			matrix[i] = matrix[i][1:len(matrix[i])]
			if len(matrix[i]) == 0 {
				matrix = matrix[0:i]
			}
		}
		if len(matrix) > 0 && len(matrix[0]) == 0 {
			matrix = [][]int{}
		}
		helper(matrix, ans, index)
	}
	var ans []int
	if len(matrix) == 0 {
		ans = []int{}
	} else {
		ans = make([]int, len(matrix)*len(matrix[0]))
	}
	helper(matrix, ans, 0)
	return ans
}
