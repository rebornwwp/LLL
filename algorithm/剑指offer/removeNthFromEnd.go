package main

import "fmt"

// Definition for singly-linked list.
type ListNode struct {
	Val  int
	Next *ListNode
}

func main() {
	head := &ListNode{
		Val: 1,
		Next: &ListNode{
			Val: 2,
			Next: &ListNode{
				Val: 3,
				Next: &ListNode{
					Val: 4,
					Next: &ListNode{
						Val: 5,
					},
				},
			},
		},
	}
	p := removeNthFromEnd(head, 2)
	for p != nil {
		if p.Next != nil {
			fmt.Printf("%v -> ", p.Val)
		} else {
			fmt.Printf("%v\n", p.Val)
		}
		p = p.Next
	}
}

/**
 * @param head: The first node of linked list.
 * @param n: An integer
 * @return: The head of linked list.
 */
func removeNthFromEnd(head *ListNode, n int) *ListNode {
	length := 0
	p := head
	for p != nil {
		length++
		p = p.Next
	}
	if n > length {
		return head
	}
	if n == length {
		return head.Next
	}
	p = head
	x := length - n
	for x > 1 {
		p = p.Next
		x--
	}
	p.Next = p.Next.Next
	return head
}
