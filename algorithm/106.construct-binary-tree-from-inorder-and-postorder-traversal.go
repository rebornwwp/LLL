/*
 * @lc app=leetcode id=106 lang=golang
 *
 * [106] Construct Binary Tree from Inorder and Postorder Traversal
 *
 * https://leetcode.com/problems/construct-binary-tree-from-inorder-and-postorder-traversal/description/
 *
 * algorithms
 * Medium (38.67%)
 * Total Accepted:    147.3K
 * Total Submissions: 381K
 * Testcase Example:  '[9,3,15,20,7]\n[9,15,7,20,3]'
 *
 * Given inorder and postorder traversal of a tree, construct the binary tree.
 *
 * Note:
 * You may assume that duplicates do not exist in the tree.
 *
 * For example, given
 *
 *
 * inorder = [9,3,15,20,7]
 * postorder = [9,15,7,20,3]
 *
 * Return the following binary tree:
 *
 *
 * ⁠   3
 * ⁠  / \
 * ⁠ 9  20
 * ⁠   /  \
 * ⁠  15   7
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
func buildTree(inorder []int, postorder []int) *TreeNode {
	length := len(inorder)
	if length == 0 {
		return nil
	}
	if length == 1 {
		return &TreeNode{Val: postorder[0]}
	}
	var ans *TreeNode
	ans = &TreeNode{Val: postorder[length-1]}
	index := find(inorder, postorder[length-1])
	ans.Left = buildTree(inorder[0:index], postorder[0:index])
	ans.Right = buildTree(inorder[index+1:], postorder[index:length-1])
	return ans
}
func find(l []int, elem int) int {
	for i, v := range l {
		if v == elem {
			return i
		}
	}
	return -1
}
