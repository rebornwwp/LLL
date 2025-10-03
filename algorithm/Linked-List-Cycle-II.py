#  Given a linked list, return the node where the cycle begins. If there is no cycle, return null.
#
# Note: Do not modify the linked list.
#
# Follow up:
# Can you solve it without using extra space?

# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None


class Solution(object):
    def detectCycle(self, head):
        """
        :type head: ListNode
        :rtype: ListNode
        """
        if not head:
            return None

        meet = None
        slow = fast = head
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            if slow == fast:
                meet = slow
                break
        while head and meet:
            if head == meet:
                return head
            head = head.next
            meet = meet.next
