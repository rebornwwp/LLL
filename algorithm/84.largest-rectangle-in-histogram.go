/*
 * @lc app=leetcode id=84 lang=golang
 *
 * [84] Largest Rectangle in Histogram
 */
package main

// func main() {
// 	a := []int{2}
// 	fmt.Println(largestRectangleArea(a))
// }
func largestRectangleArea(heights []int) int {
	stack := make([]int, 0)
	stack = append(stack, -1)
	ans := 0
	for i := 0; i <= len(heights); i++ {
		for len(stack) > 1 && (i >= len(heights) || heights[stack[len(stack)-1]] >= heights[i]) {
			lastIndex := stack[len(stack)-1]
			stack = stack[0 : len(stack)-1]
			peek := stack[len(stack)-1]
			ans = max(ans, heights[lastIndex]*(i-peek-1))
		}
		stack = append(stack, i)
	}
	return ans
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
