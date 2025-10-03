/*
 * @lc app=leetcode id=203 lang=golang
 *
 * [203] Remove Linked List Elements
 *
 * https://leetcode.com/problems/remove-linked-list-elements/description/
 *
 * algorithms
 * Easy (35.43%)
 * Total Accepted:    214.9K
 * Total Submissions: 605.3K
 * Testcase Example:  '[1,2,6,3,4,5,6]\n6'
 *
 * Remove all elements from a linked list of integers that have value val.
 *
 * Example:
 *
 *
 * Input:  1->2->6->3->4->5->6, val = 6
 * Output: 1->2->3->4->5
 *
 *
 */

// Definition for singly-linked list.
package main

import "fmt"

func main() {
	l := &ListNode{
		Val: 1,
		Next: &ListNode{
			Val: 2,
			Next: &ListNode{
				Val: 6,
				Next: &ListNode{
					Val: 3,
					Next: &ListNode{
						Val: 4,
						Next: &ListNode{
							Val:  5,
							Next: &ListNode{Val: 6}}}}}}}

	ans := removeElements(l, 6)
	for ans != nil {
		fmt.Println(ans.Val)
		ans = ans.Next
	}
}

type ListNode struct {
	Val  int
	Next *ListNode
}

func removeElements(head *ListNode, val int) *ListNode {
	ans := ListNode{Next: head}
	temp := &ans
	for temp.Next != nil {
		if temp.Next.Val == val {
			temp.Next = temp.Next.Next
		} else {
			temp = temp.Next
		}
	}
	return ans.Next
}
