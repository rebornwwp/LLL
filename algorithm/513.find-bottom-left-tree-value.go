/*
 * @lc app=leetcode id=513 lang=golang
 *
 * [513] Find Bottom Left Tree Value
 *
 * https://leetcode.com/problems/find-bottom-left-tree-value/description/
 *
 * algorithms
 * Medium (58.19%)
 * Total Accepted:    69K
 * Total Submissions: 118.6K
 * Testcase Example:  '[2,1,3]'
 *
 *
 * Given a binary tree, find the leftmost value in the last row of the tree.
 *
 *
 * Example 1:
 *
 * Input:
 *
 * ⁠   2
 * ⁠  / \
 * ⁠ 1   3
 *
 * Output:
 * 1
 *
 *
 *
 * ⁠ Example 2:
 *
 * Input:
 *
 * ⁠       1
 * ⁠      / \
 * ⁠     2   3
 * ⁠    /   / \
 * ⁠   4   5   6
 * ⁠      /
 * ⁠     7
 *
 * Output:
 * 7
 *
 *
 *
 * Note:
 * You may assume the tree (i.e., the given root node) is not NULL.
 *
 */

package main

import "fmt"

func main() {
	fmt.Println("hello")
}

// Definition for a binary tree node.
type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func findBottomLeftValue(root *TreeNode) int {
	res := findLeftView(root)
	return res[len(res)-1]
}

func findLeftView(node *TreeNode) []int {
	if node == nil {
		return []int{}
	}
	left := findLeftView(node.Left)
	right := findLeftView(node.Right)
	if len(left) < len(right) {
		left = append(left, right[len(left):]...)
	}
	res := []int{node.Val}
	res = append(res, left...)
	return res
}

func findBottomLeftValue1(root *TreeNode) int {
	queue := []*TreeNode{root}
	for len(queue) > 0 {
		root = queue[0]
		queue = queue[1:]
		if root.Left != nil {
			queue = append(queue, root.Left)
		}
		if root.Right != nil {
			queue = append(queue, root.Right)
		}
	}

	return root.Val
}
