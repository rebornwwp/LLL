#
# @lc app=leetcode id=445 lang=python
#
# [445] Add Two Numbers II
#
# https://leetcode.com/problems/add-two-numbers-ii/description/
#
# algorithms
# Medium (49.51%)
# Total Accepted:    83.6K
# Total Submissions: 168.8K
# Testcase Example:  '[7,2,4,3]\n[5,6,4]'
#
# You are given two non-empty linked lists representing two non-negative
# integers. The most significant digit comes first and each of their nodes
# contain a single digit. Add the two numbers and return it as a linked list.
#
# You may assume the two numbers do not contain any leading zero, except the
# number 0 itself.
#
# Follow up:
# What if you cannot modify the input lists? In other words, reversing the
# lists is not allowed.
#
#
#
# Example:
#
# Input: (7 -> 2 -> 4 -> 3) + (5 -> 6 -> 4)
# Output: 7 -> 8 -> 0 -> 7
#
#
#
# Definition for singly-linked list.


class ListNode(object):
    def __init__(self, x):
        self.val = x
        self.next = None


class Solution(object):
    def addTwoNumbers(self, l1, l2):
        """
        :type l1: ListNode
        :type l2: ListNode
        :rtype: ListNode
        """
        h = l1
        ll1 = []
        while h:
            ll1.append(h)
            h = h.next

        h = l2
        ll2 = []
        while h:
            ll2.append(h)
            h = h.next
        ans = l1
        if len(ll2) > len(ll1):
            ll1, ll2 = ll2, ll1
            ans = l2

        curry = 0
        while len(ll1) > 0 and len(ll2) > 0:
            node1 = ll1.pop()
            node2 = ll2.pop()
            t = node1.val + node2.val + curry
            curry = t // 10
            node1.val = t % 10

        while len(ll1) > 0:
            node = ll1.pop()
            t = node.val + curry
            curry = t // 10
            node.val = t % 10

        if curry >= 1:
            t = ListNode(curry)
            t.next = ans
            ans = t
        return ans
