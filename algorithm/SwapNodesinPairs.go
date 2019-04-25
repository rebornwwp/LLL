package main

import "fmt"

// Definition for singly-linked list.
type ListNode struct {
	Val  int
	Next *ListNode
}

func main() {
	a := &ListNode{
		Val: 1,
		Next: &ListNode{
			Val: 2,
			Next: &ListNode{
				Val: 3,
			},
		},
	}
	printListNode(swapPairs(a))
}
func printListNode(head *ListNode) {
	ans := make([]int, 0)
	for head != nil {
		ans = append(ans, head.Val)
		head = head.Next
	}
	fmt.Println(ans)
}

func swapPairs(head *ListNode) *ListNode {

	var helper func(*ListNode)

	helper = func(node *ListNode) {
		if node.Next == nil {
			return
		}
		if node.Next.Next == nil {
			return
		}
		temp := node.Next
		tempNext := temp.Next
		temp.Next = tempNext.Next
		tempNext.Next = temp
		node.Next = tempNext
		helper(node.Next.Next)
	}
	temp := &ListNode{
		Val:  0,
		Next: head,
	}
	helper(temp)
	return temp.Next
}
