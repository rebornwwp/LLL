package main

import "fmt"

func main() {
	var matrix [][]int
	target := 1
	fmt.Println(len(matrix))
	fmt.Println(searchMatrix1(matrix, target))
}

/**
 * @param matrix: A list of lists of integers
 * @param target: An integer you want to search in matrix
 * @return: An integer indicate the total occurrence of target in the given matrix
 */
func searchMatrix(matrix [][]int, target int) int {
	count := 0
	i, j := 0, len(matrix[0])-1
	for i < len(matrix) && j >= 0 {
		if matrix[i][j] < target {
			i++
		} else if matrix[i][j] > target {
			j--
		} else {
			count++
			i++
		}
	}
	return count
}

func searchMatrix1(matrix [][]int, target int) bool {
	if len(matrix) == 0 {
		return false
	}

	m, n := len(matrix), len(matrix[0])
	i, j := 0, m-1
	rowMid := 0
	for i <= j {
		mid := int((i + j) / 2)
		if matrix[mid][0] <= target && target <= matrix[mid][len(matrix[mid])-1] {
			rowMid = mid
			break
		} else if target < matrix[mid][0] {
			j = mid - 1
		} else if target > matrix[mid][len(matrix)-1] {
			i = mid + 1
		}
	}
	if i > j {
		return false
	}
	start, end := 0, n-1
	for start <= end {
		colMid := int((start + end) / 2)
		if matrix[rowMid][colMid] == target {
			return true
		} else if matrix[rowMid][colMid] > target {
			end = colMid - 1
		} else {
			start = colMid + 1
		}
	}
	return false
}
