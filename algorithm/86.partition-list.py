#
# @lc app=leetcode id=86 lang=python
#
# [86] Partition List
#
# https://leetcode.com/problems/partition-list/description/
#
# algorithms
# Medium (36.56%)
# Total Accepted:    156K
# Total Submissions: 426.5K
# Testcase Example:  '[1,4,3,2,5,2]\n3'
#
# Given a linked list and a value x, partition it such that all nodes less than
# x come before nodes greater than or equal to x.
#
# You should preserve the original relative order of the nodes in each of the
# two partitions.
#
# Example:
#
#
# Input: head = 1->4->3->2->5->2, x = 3
# Output: 1->2->2->4->3->5
#
#
#
# Definition for singly-linked list.


class ListNode(object):
    def __init__(self, x):
        self.val = x
        self.next = None


class Solution(object):
    def partition(self, head, x):
        """
        :type head: ListNode
        :type x: int
        :rtype: ListNode
        """
        left = ListNode(-1)
        l = left
        right = ListNode(-1)
        r = right
        h = head
        while h:
            if h.val < x:
                l.next = ListNode(h.val)
                l = l.next
            else:
                r.next = ListNode(h.val)
                r = r.next
            h = h.next
        l.next = right.next
        return left.next
