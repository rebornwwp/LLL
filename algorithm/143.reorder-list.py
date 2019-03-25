#
# @lc app=leetcode id=143 lang=python
#
# [143] Reorder List
#
# https://leetcode.com/problems/reorder-list/description/
#
# algorithms
# Medium (30.10%)
# Total Accepted:    146.1K
# Total Submissions: 485.6K
# Testcase Example:  '[1,2,3,4]'
#
# Given a singly linked list L: L0→L1→…→Ln-1→Ln,
# reorder it to: L0→Ln→L1→Ln-1→L2→Ln-2→…
#
# You may not modify the values in the list's nodes, only nodes itself may be
# changed.
#
# Example 1:
#
#
# Given 1->2->3->4, reorder it to 1->4->2->3.
#
# Example 2:
#
#
# Given 1->2->3->4->5, reorder it to 1->5->2->4->3.
#
#
#
# Definition for singly-linked list.


class ListNode(object):
    def __init__(self, x):
        self.val = x
        self.next = None


class Solution(object):
    def reorderList(self, head):
        """
        :type head: ListNode
        :rtype: None Do not return anything, modify head in-place instead.
        """
        if not head:
            return None
        l = []
        h = head
        while h:
            l.append(h)
            h = h.next
        a = []
        i = 0
        j = len(l) - 1
        while i <= j:
            if i == j:
                a.append(l[i])
            else:
                a.append(l[i])
                a.append(l[j])
            i += 1
            j -= 1
        for i in range(len(l) - 1):
            a[i].next = a[i + 1]
        a[-1].next = None
        return a[0]


s = Solution()
l = ListNode(1)
l.next = ListNode(2)
l.next.next = ListNode(3)
l.next.next.next = ListNode(4)
h = s.reorderList(l)
while h:
    print(h.val)
    h = h.next
