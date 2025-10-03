#
# @lc app=leetcode id=203 lang=python
#
# [203] Remove Linked List Elements
#
# https://leetcode.com/problems/remove-linked-list-elements/description/
#
# algorithms
# Easy (35.41%)
# Total Accepted:    212K
# Total Submissions: 598.8K
# Testcase Example:  '[1,2,6,3,4,5,6]\n6'
#
# Remove all elements from a linked list of integers that have value val.
#
# Example:
#
#
# Input:  1->2->6->3->4->5->6, val = 6
# Output: 1->2->3->4->5
#
#
#
# Definition for singly-linked list.


class ListNode(object):
    def __init__(self, x):
        self.val = x
        self.next = None


class Solution(object):
    def removeElements(self, head, val):
        """
        :type head: ListNode
        :type val: int
        :rtype: ListNode
        """
        p = ListNode(-1)
        p1 = p
        h = head
        while h:
            if h.val != val:
                p1.next = h
                p1 = p1.next
            h = h.next
        p1.next = None
        return p.next
