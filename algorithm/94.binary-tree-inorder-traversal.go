/*
 * @lc app=leetcode id=94 lang=golang
 *
 * [94] Binary Tree Inorder Traversal
 *
 * https://leetcode.com/problems/binary-tree-inorder-traversal/description/
 *
 * algorithms
 * Medium (55.56%)
 * Total Accepted:    432.5K
 * Total Submissions: 775.6K
 * Testcase Example:  '[1,null,2,3]'
 *
 * Given a binary tree, return the inorder traversal of its nodes' values.
 *
 * Example:
 *
 *
 * Input: [1,null,2,3]
 * ⁠  1
 * ⁠   \
 * ⁠    2
 * ⁠   /
 * ⁠  3
 *
 * Output: [1,3,2]
 *
 * Follow up: Recursive solution is trivial, could you do it iteratively?
 *
 */
//Definition for a binary tree node.

package main

import (
	"container/list"
	"fmt"
)

type TreeNode struct {
	Val   int
	Left  *TreeNode
	Right *TreeNode
}

func main() {
	t := TreeNode
	fmt.Println(append([]int{1, 2}, []int{3, 4}...))
	fmt.Println("hell")
}

func inorderTraversal1(root *TreeNode) []int {
	l := list.New()
	ans := []int{}
	current := root
	done := false
	for !done {
		if current != nil {
			l.PushBack(current)
			current = current.Left
		} else {
			if l.Len() != 0 {
				temp := l.Back().Value.(*TreeNode)
				ans = append(ans, temp.Val)
				l.Remove(l.Back())
				current = temp.Right
			} else {
				done = true
			}
		}
	}
	return ans
}

func inorderTraversal(root *TreeNode) []int {
	if root == nil {
		return []int{}
	}
	return append(inorderTraversal(root.Left), append([]int{root.Val}, inorderTraversal(root.Right)...)...)
}
