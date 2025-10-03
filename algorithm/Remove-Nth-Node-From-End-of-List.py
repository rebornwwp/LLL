# Given a linked list, remove the n-th node from the end of list and return its head.
#
# Example:
#
# Given linked list: 1->2->3->4->5, and n = 2.
#
# After removing the second node from the end, the linked list becomes 1->2->3->5.
# Note:
#
# Given n will always be valid.
#
# Follow up:
#
# Could you do this in one pass?


# Definition for singly-linked list.
class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None


class Solution:
    def removeNthFromEnd(self, head, n):
        """
        :type head: ListNode
        :type n: int
        :rtype: ListNode
        """
        counter = 0
        a = head
        while a:
            counter += 1
            a = a.next
        total = counter

        counter = 1
        a = head
        if n == total:
            return a.next

        while counter != total - n:
            a = a.next
            counter += 1
        if n == 1:
            a.next = None
        else:
            a.next = a.next.next
        return head

    def removeNthFromEnd1(self, head, n):
        p1 = head
        p2 = head
        temp = n
        while temp > 0:
            p1 = p1.next
            temp -= 1
        # n 等于链表的长度的时候
        if not p1:
            return head.next
        while p1.next:
            p1 = p1.next
            p2 = p2.next
        p2.next = p2.next.next
        return head
