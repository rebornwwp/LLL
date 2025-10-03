#
# @lc app=leetcode id=82 lang=python
#
# [82] Remove Duplicates from Sorted List II
#
# https://leetcode.com/problems/remove-duplicates-from-sorted-list-ii/description/
#
# algorithms
# Medium (32.38%)
# Total Accepted:    172K
# Total Submissions: 531.3K
# Testcase Example:  '[1,2,3,3,4,4,5]'
#
# Given a sorted linked list, delete all nodes that have duplicate numbers,
# leaving only distinct numbers from the original list.
#
# Example 1:
#
#
# Input: 1->2->3->3->4->4->5
# Output: 1->2->5
#
#
# Example 2:
#
#
# Input: 1->1->1->2->3
# Output: 2->3
#
#
#
# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None


class Solution(object):
    def deleteDuplicates(self, head):
        """
        :type head: ListNode
        :rtype: ListNode
        """
        if not head:
            return head
        prev = None
        ans = None
        h = head
        while h and h.next:
            if h.val != h.next.val:
                if prev is None:
                    ans = h
                    prev = h
                else:
                    prev.next = h
                    prev = prev.next
                h = h.next
            else:
                t = h.next
                while t is not None and h.val == t.val:
                    t = t.next
                h = t
        if prev:
            prev.next = h
        else:
            ans = h
        return ans
