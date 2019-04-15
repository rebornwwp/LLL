/*
 * @lc app=leetcode id=111 lang=golang
 *
 * [111] Minimum Depth of Binary Tree
 *
 * https://leetcode.com/problems/minimum-depth-of-binary-tree/description/
 *
 * algorithms
 * Easy (35.09%)
 * Total Accepted:    285.1K
 * Total Submissions: 812.4K
 * Testcase Example:  '[3,9,20,null,null,15,7]'
 *
 * Given a binary tree, find its minimum depth.
 *
 * The minimum depth is the number of nodes along the shortest path from the
 * root node down to the nearest leaf node.
 *
 * Note: A leaf is a node with no children.
 *
 * Example:
 *
 * Given binary tree [3,9,20,null,null,15,7],
 *
 *
 * ⁠   3
 * ⁠  / \
 * ⁠ 9  20
 * ⁠   /  \
 * ⁠  15   7
 *
 * return its minimum depth = 2.
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
func minDepth(root *TreeNode) int {
	switch {
	case root == nil:
		return 0
	case root.Left == nil:
		return 1 + minDepth(root.Right)
	case root.Right == nil:
		return 1 + minDepth(root.Left)
	default:
		return 1 + min(minDepth(root.Left), minDepth(root.Right))
	}
}

func min(a, b int) int {
	if a > b {
		return b
	}
	return a
}

