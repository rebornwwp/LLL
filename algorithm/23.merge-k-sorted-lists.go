/*
 * @lc app=leetcode id=23 lang=golang
 *
 * [23] Merge k Sorted Lists
 */

package main

import "fmt"

func main() {
	fmt.Println("hello")
}

// Definition for singly-linked list.
type ListNode struct {
	Val  int
	Next *ListNode
}

func mergeKLists(lists []*ListNode) *ListNode {
	if len(lists) == 0 {
		return nil
	}
	return merge(lists)
}

func merge(lists []*ListNode) *ListNode {
	length := len(lists)
	half := len(lists) / 2
	if length == 1 {
		return lists[0]
	}
	if length == 2 {
		l1 := lists[0]
		l2 := lists[1]
		ans := &ListNode{}
		tmp := ans
		for l1 != nil && l2 != nil {
			if l1.Val < l2.Val {
				tmp.Next = l1
				tmp = tmp.Next
				l1 = l1.Next
			} else {
				tmp.Next = l2
				tmp = tmp.Next
				l2 = l2.Next
			}
		}
		for l1 != nil {
			tmp.Next = l1
			tmp = tmp.Next
			l1 = l1.Next
		}
		for l2 != nil {
			tmp.Next = l2
			tmp = tmp.Next
			l2 = l2.Next
		}
		return ans.Next
	}
	return mergeKLists([]*ListNode{merge(lists[0:half]), merge(lists[half:len(lists)])})
}
