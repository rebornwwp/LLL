# Given a linked list, swap every two adjacent nodes and return its head.

# You may not modify the values in the list's nodes, only nodes itself may be changed.
# Example:
# Given 1->2->3->4, you should return the list as 2->1->4->3.

# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None


class Solution(object):
    def swapPairs(self, head):
        """
        :type head: ListNode
        :rtype: ListNode
        """
        h = head
        while h.next is not None and h.next.next:
            h.val, h.next.val = h.next.val, h.val
            h = h.next.next
