package main

import "fmt"

// Definition for singly-linked list.
type ListNode struct {
	Val  int
	Next *ListNode
}

func main() {
	l1 := &ListNode{
		Val: 1,
		Next: &ListNode{
			Val: 2,
			Next: &ListNode{
				Val: 3,
			},
		},
	}
	l2 := &ListNode{
		Val: 1,
		Next: &ListNode{
			Val: 2,
			Next: &ListNode{
				Val: 3,
			},
		},
	}
	l := mergeTwoLists(l1, l2)
	for l != nil {
		if l.Next != nil {
			fmt.Printf("%v -> ", l.Val)
		} else {
			fmt.Printf("%v\n", l.Val)
		}
		l = l.Next
	}
}

/**
 * @param l1: ListNode l1 is the head of the linked list
 * @param l2: ListNode l2 is the head of the linked list
 * @return: ListNode head of linked list
 */
func mergeTwoLists(l1 *ListNode, l2 *ListNode) *ListNode {
	p := &ListNode{Val: 0}
	ans := p
	for l1 != nil && l2 != nil {
		if l1.Val >= l2.Val {
			p.Next = &ListNode{Val: l2.Val}
			l2 = l2.Next
		} else {
			p.Next = &ListNode{Val: l1.Val}
			l1 = l1.Next
		}
		p = p.Next
	}
	for l1 != nil {
		p.Next = &ListNode{Val: l1.Val}
		p = p.Next
		l1 = l1.Next
	}
	for l2 != nil {
		p.Next = &ListNode{Val: l2.Val}
		p = p.Next
		l2 = l2.Next
	}
	return ans.Next
}
