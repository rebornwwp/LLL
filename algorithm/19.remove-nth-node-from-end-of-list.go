/*
 * @lc app=leetcode id=19 lang=golang
 *
 * [19] Remove Nth Node From End of List
 *
 * https://leetcode.com/problems/remove-nth-node-from-end-of-list/description/
 *
 * algorithms
 * Medium (34.08%)
 * Total Accepted:    372.1K
 * Total Submissions: 1.1M
 * Testcase Example:  '[1,2,3,4,5]\n2'
 *
 * Given a linked list, remove the n-th node from the end of list and return
 * its head.
 *
 * Example:
 *
 *
 * Given linked list: 1->2->3->4->5, and n = 2.
 *
 * After removing the second node from the end, the linked list becomes
 * 1->2->3->5.
 *
 *
 * Note:
 *
 * Given n will always be valid.
 *
 * Follow up:
 *
 * Could you do this in one pass?
 *
 */

// Definition for singly-linked list.

package main

import "fmt"

func main() {
	fmt.Println("he")
}

type ListNode struct {
	Val  int
	Next *ListNode
}

func removeNthFromEnd(head *ListNode, n int) *ListNode {
	count := 0
	h := ListNode{Next: head}
	temp := &h
	for temp != nil {
		count++
		temp = temp.Next
	}
	temp = &h
	for i := 1; i < count-n; i++ {
		temp = temp.Next
	}
	temp.Next = temp.Next.Next
	return h.Next
}
