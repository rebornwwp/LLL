// Given the root of a binary search tree with distinct values, modify it so that every node has a new value equal to the sum of the values of the original tree that are greater than or equal to node.val.
// As a reminder, a binary search tree is a tree that satisfies these constraints:
// The left subtree of a node contains only nodes with keys less than the node's key.
// The right subtree of a node contains only nodes with keys greater than the node's key.
// Both the left and right subtrees must also be binary search trees.

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

func bstToGst(root *TreeNode) *TreeNode {
	var helper func(*TreeNode, *int) *TreeNode
	helper = func(node *TreeNode, sum *int) *TreeNode {
		var ans *TreeNode = nil
		if node == nil {
			return ans
		}
		right := helper(node.Right, sum)
		*sum += node.Val
		tmp := *sum
		left := helper(node.Left, sum)
		ans = &TreeNode{
			Val:   tmp,
			Left:  left,
			Right: right,
		}
		return ans
	}
	var sum int = 0
	ans := helper(root, &sum)
	return ans
}
