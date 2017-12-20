# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None


class Solution(object):
    def getIntersectionNode(self, headA, headB):
        """
        :type head1, head1: ListNode
        :rtype: ListNode
        """
        lenA = self.length(headA)
        lenB = self.length(headB)
        diff = lenA - lenB
        if diff > 0:
            while diff > 0:
                headA = headA.next
                diff -= 1
        else:
            while diff < 0:
                headB = headB.next
                diff += 1
        while headA != headB:
            headA = headA.next
            headB = headB.next
        return headA

    def length(self, linked_list):
        len = 0
        while linked_list:
            len += 1
            linked_list = linked_list.next
        return len


class Solution2(object):
    def getIntersectionNode(self, headA, headB):
        """
        :type head1, head1: ListNode
        :rtype: ListNode
        """
        if headA is None or headB is None:
            return None

        pa = headA
        pb = headB
        while pa is not pb:
            pa = headB if pa is None else pa.next
            pb = headA if pb is None else pb.next
        return pa
