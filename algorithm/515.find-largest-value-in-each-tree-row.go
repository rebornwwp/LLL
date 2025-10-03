/*
 * @lc app=leetcode id=515 lang=golang
 *
 * [515] Find Largest Value in Each Tree Row
 *
 * https://leetcode.com/problems/find-largest-value-in-each-tree-row/description/
 *
 * algorithms
 * Medium (57.56%)
 * Total Accepted:    61.5K
 * Total Submissions: 106.8K
 * Testcase Example:  '[1,3,2,5,3,null,9]'
 *
 * You need to find the largest value in each row of a binary tree.
 *
 * Example:
 *
 * Input:
 *
 * ⁠         1
 * ⁠        / \
 * ⁠       3   2
 * ⁠      / \   \
 * ⁠     5   3   9
 *
 * Output: [1, 3, 9]
 *
 *
 *
 */
/**
 * Definition for a binary tree node.
 * type TreeNode struct {
 *     Val int
 *     Left *TreeNode
 *     Right *TreeNode
 * }
 */
package main

import "fmt"

func main() {
	fmt.Println("hello")
}

func largestValues(root *TreeNode) []int {
	ans := []int{}
	var dfs func(*TreeNode, int)
	dfs = func(root *TreeNode, level int) {
		if root == nil {
			return
		}
		if level >= len(ans) {
			ans = append(ans, root.Val)
		} else {
			ans[level] = max(ans[level], root.Val)
		}
		dfs(root.Left, level+1)
		dfs(root.Right, level+1)
	}
	dfs(root, 0)
	return ans
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
