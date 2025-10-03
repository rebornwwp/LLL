# Definition for singly-linked list.
# class ListNode(object):
#     def __init__(self, x):
#         self.val = x
#         self.next = None

class Solution(object):
    def mergeTwoLists(self, l1, l2):
        """
        :type l1: ListNode
        :type l2: ListNode
        :rtype: ListNode
        """
        result = ListNode(0)
        temp = result
        while (l1 is not None and l2 is not None):
            if l1.val < l2.val:
                temp.next = ListNode(l1.val)
                l1 = l1.next
            else:
                temp.next = ListNode(l2.val)
                l2 = l2.next
            temp = temp.next
        while (l1 is not None):
            temp.next = ListNode(l1.val)
            l1 = l1.next
            temp = temp.next
        while (l2 is not None):
            temp.next = ListNode(l2.val)
            l2 = l2.next
            temp = temp.next
        return result.next


