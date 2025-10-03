#
# @lc app=leetcode id=92 lang=python
#
# [92] Reverse Linked List II
#
# https://leetcode.com/problems/reverse-linked-list-ii/description/
#
# algorithms
# Medium (34.28%)
# Total Accepted:    183.2K
# Total Submissions: 534.5K
# Testcase Example:  '[1,2,3,4,5]\n2\n4'
#
# Reverse a linked list from position m to n. Do it in one-pass.
#
# Note: 1 ≤ m ≤ n ≤ length of list.
#
# Example:
#
#
# Input: 1->2->3->4->5->NULL, m = 2, n = 4
# Output: 1->4->3->2->5->NULL
#
#
#
# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None


class Solution(object):
    def reverseBetween(self, head, m, n):
        """
        :type head: ListNode
        :type m: int
        :type n: int
        :rtype: ListNode
        """
        if not head:
            return head
        reverse_l = None
        h = head
        p1 = None
        p2 = None
        count = 1
        while h:
            if count < m:
                p1 = h
                h = h.next
            elif m <= count <= n:
                h_next = h.next
                h.next = reverse_l
                reverse_l = h
                h = h_next
                if m == count:
                    reverse_l_end = reverse_l
            elif count == n + 1:
                p2 = h
                h = h.next
            else:
                h = h.next
            count += 1

        reverse_l_end.next = p2
        if p1:
            p1.next = reverse_l
            return head
        else:
            return reverse_l
