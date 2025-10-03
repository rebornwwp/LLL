/*
 * @lc app=leetcode id=85 lang=golang
 *
 * [85] Maximal Rectangle
 *
 * https://leetcode.com/problems/maximal-rectangle/description/
 *
 * algorithms
 * Hard (32.71%)
 * Total Accepted:    115.3K
 * Total Submissions: 352.3K
 * Testcase Example:  '[["1","0","1","0","0"],["1","0","1","1","1"],["1","1","1","1","1"],["1","0","0","1","0"]]'
 *
 * Given a 2D binary matrix filled with 0's and 1's, find the largest rectangle
 * containing only 1's and return its area.
 *
 * Example:
 *
 *
 * Input:
 * [
 * ⁠ ["1","0","1","0","0"],
 * ⁠ ["1","0","1","1","1"],
 * ⁠ ["1","1","1","1","1"],
 * ⁠ ["1","0","0","1","0"]
 * ]
 * Output: 6
 *
 *
 */
package main

// func main() {
// 	matrix := [][]byte{
// 		[]byte{'1', '0', '1', '0', '0'},
// 		[]byte{'1', '0', '1', '1', '1'},
// 		[]byte{'1', '1', '1', '1', '1'},
// 		[]byte{'1', '0', '0', '1', '0'},
// 	}
// 	fmt.Println(maximalRectangle(matrix))
// }

func maximalRectangle(matrix [][]byte) int {
	if len(matrix) <= 0 {
		return 0
	}
	histagrams := make([][]int, len(matrix))
	for i := range histagrams {
		histagrams[i] = make([]int, len(matrix[0]))
	}
	ans := 0
	for i := range matrix[0] {
		if matrix[0][i] == '1' {
			histagrams[0][i] = 1
		} else {
			histagrams[0][i] = 0
		}
		ans = max(ans, maxHistagramRec(histagrams[0]))
	}
	for i := 1; i < len(matrix); i++ {
		for j := 0; j < len(matrix[0]); j++ {
			if matrix[i][j] == '1' {
				histagrams[i][j] = histagrams[i-1][j] + 1
			} else {
				histagrams[i][j] = 0
			}
		}
		ans = max(ans, maxHistagramRec(histagrams[i]))
	}
	return ans
}

func maxHistagramRec(heights []int) int {
	stack := make([]int, 0)
	stack = append(stack, -1)
	ans := 0
	for i := 0; i <= len(heights); i++ {
		for len(stack) > 1 && (i >= len(heights) || heights[stack[len(stack)-1]] >= heights[i]) {
			last_index := stack[len(stack)-1]
			stack = stack[0 : len(stack)-1]
			peek := stack[len(stack)-1]
			ans = max(ans, heights[last_index]*(i-peek-1))
		}
		stack = append(stack, i)
	}
	return ans
}
func max(x ...int) int {
	ans := x[0]
	for _, v := range x {
		if v > ans {
			ans = v
		}
	}
	return ans
}
