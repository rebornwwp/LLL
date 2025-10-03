package main

import (
	"fmt"
	"strings"
)

// Given a matrix consisting of 0s and 1s, we may choose any number of columns in the matrix and flip every cell in that column.  Flipping a cell changes the value of that cell from 0 to 1 or from 1 to 0.
//
// Return the maximum number of rows that have all values equal after some number of flips.
//
//
//
// Example 1:
//
// Input: [[0,1],[1,1]]
// Output: 1
// Explanation: After flipping no values, 1 row has all values equal.
// Example 2:
//
// Input: [[0,1],[1,0]]
// Output: 2
// Explanation: After flipping values in the first column, both rows have equal values.
// Example 3:
//
// Input: [[0,0,0],[0,0,1],[1,1,0]]
// Output: 2
// Explanation: After flipping values in the first two columns, the last two rows have equal values.
//
//
// Note:
//
// 1 <= matrix.length <= 300
// 1 <= matrix[i].length <= 300
// All matrix[i].length's are equal
// matrix[i][j] is 0 or 1

func main() {
	matrix := [][]int{[]int{0, 0, 0}, []int{0, 0, 1}, []int{1, 1, 0}}
	fmt.Println(maxEqualRowsAfterFlips(matrix))
}
func maxEqualRowsAfterFlips(matrix [][]int) int {
	counter := make(map[string]int)
	for i := range matrix {
		pattern := getRowPattern(matrix[i])
		counter[pattern]++
	}
	ans := 0
	for _, v := range counter {
		if v > ans {
			ans = v
		}
	}
	return ans
}

func getRowPattern(row []int) string {
	builder := strings.Builder{}
	builder.Grow(len(row))
	for i := range row {
		if row[i] == row[0] {
			builder.WriteByte('1')
		} else {
			builder.WriteByte('0')
		}
	}
	return builder.String()
}
