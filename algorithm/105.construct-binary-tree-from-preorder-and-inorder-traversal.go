/*
 * @lc app=leetcode id=105 lang=golang
 *
 * [105] Construct Binary Tree from Preorder and Inorder Traversal
 *
 * https://leetcode.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/description/
 *
 * algorithms
 * Medium (40.33%)
 * Total Accepted:    212.6K
 * Total Submissions: 527K
 * Testcase Example:  '[3,9,20,15,7]\n[9,3,15,20,7]'
 *
 * Given preorder and inorder traversal of a tree, construct the binary tree.
 *
 * Note:
 * You may assume that duplicates do not exist in the tree.
 *
 * For example, given
 *
 *
 * preorder = [3,9,20,15,7]
 * inorder = [9,3,15,20,7]
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
	fmt.Println("hello")
}

func buildTree(preorder []int, inorder []int) *TreeNode {
	if len(preorder) == 0 {
		return nil
	}
	if len(preorder) == 1 {
		return &TreeNode{Val: preorder[0]}
	}
	var ans *TreeNode
	ans = &TreeNode{Val: preorder[0]}
	index := find(inorder, preorder[0])
	ans.Left = buildTree(preorder[1:1+index], inorder[0:index])
	ans.Right = buildTree(preorder[index+1:], inorder[index+1:])
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
