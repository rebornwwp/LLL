package main

import "fmt"

func main() {
	ans := generate(5)
	for i := 0; i < len(ans); i++ {
		fmt.Println(ans[i])
	}
	fmt.Println(getRow(5))
}

func generate(numRows int) [][]int {
	var helper func([][]int, int)

	helper = func(ans [][]int, level int) {
		if level > numRows {
			return
		}

		for i := 0; i < level; i++ {
			if i == 0 || i == level-1 {
				ans[level-1][i] = 1
			} else {
				ans[level-1][i] = ans[level-2][i-1] + ans[level-2][i]
			}
		}
		helper(ans, level+1)
	}
	ans := make([][]int, numRows)
	for i := 0; i < numRows; i++ {
		ans[i] = make([]int, i+1)
	}
	helper(ans, 1)
	return ans
}

func getRow(rowIndex int) []int {

	var helper func([]int, int)

	helper = func(ans []int, level int) {
		if level > rowIndex+1 {
			return
		}

		for i := level - 1; i >= 0; i-- {
			if i == 0 || i == level-1 {
				ans[i] = 1
			} else {
				ans[i] = ans[i-1] + ans[i]
			}
		}
		helper(ans, level+1)
	}
	ans := make([]int, rowIndex+1)

	helper(ans, 1)
	return ans
}
