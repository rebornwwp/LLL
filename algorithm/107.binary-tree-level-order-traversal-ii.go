/*
 * @lc app=leetcode id=107 lang=golang
 *
 * [107] Binary Tree Level Order Traversal II
 *
 * https://leetcode.com/problems/binary-tree-level-order-traversal-ii/description/
 *
 * algorithms
 * Easy (46.22%)
 * Total Accepted:    217.9K
 * Total Submissions: 471.6K
 * Testcase Example:  '[3,9,20,null,null,15,7]'
 *
 * Given a binary tree, return the bottom-up level order traversal of its
 * nodes' values. (ie, from left to right, level by level from leaf to root).
 *
 *
 * For example:
 * Given binary tree [3,9,20,null,null,15,7],
 *
 * ⁠   3
 * ⁠  / \
 * ⁠ 9  20
 * ⁠   /  \
 * ⁠  15   7
 *
 *
 *
 * return its bottom-up level order traversal as:
 *
 * [
 * ⁠ [15,7],
 * ⁠ [9,20],
 * ⁠ [3]
 * ]
 *
 *
 */

package main

import "fmt"

// Definition for a binary tree node.
type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func main() {
	a := &TreeNode{
		Val:  3,
		Left: &TreeNode{Val: 9},
		Right: &TreeNode{
			Val:   20,
			Left:  &TreeNode{Val: 15},
			Right: &TreeNode{Val: 7},
		},
	}
	fmt.Println(levelOrderBottom(a))
}

func levelOrderBottom(root *TreeNode) [][]int {
	d := depth(root)
	ans := make([][]int, d)
	for i := range ans {
		ans[i] = make([]int, 0)
	}
	var dfs func(*TreeNode, int)
	dfs = func(root *TreeNode, level int) {
		if root == nil {
			return
		}
		ans[d-level] = append(ans[d-level], root.Val)
		dfs(root.Left, level+1)
		dfs(root.Right, level+1)
	}
	dfs(root, 1)
	return ans
}

func depth(root *TreeNode) int {
	if root == nil {
		return 0
	}
	return 1 + max(depth(root.Left), depth(root.Right))
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
