/*
 * @lc app=leetcode id=48 lang=golang
 *
 * [48] Rotate Image
 */
package main

// func main() {
// 	matrix := [][]int{
// 		[]int{1, 2, 3, 4},
// 		[]int{5, 6, 7, 8},
// 		[]int{9, 10, 11, 12},
// 		[]int{13, 14, 15, 16},
// 	}
// 	rotate(matrix)
// 	fmt.Println(matrix)
// }

func rotate(matrix [][]int) {
	length := len(matrix) - 1
	for i := 0; i <= length; i++ {
		for j := i; j <= length; j++ {
			tmp := matrix[i][j]
			matrix[i][j] = matrix[j][i]
			matrix[j][i] = tmp
		}
	}
	for i := range matrix {
		start := 0
		end := length
		for start < end {
			matrix[i][start], matrix[i][end] = matrix[i][end], matrix[i][start]
			start++
			end--
		}
	}
}
