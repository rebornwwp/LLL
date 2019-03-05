# Reverse a singly linked list.
# Example:
# Input: 1->2->3->4->5->NULL
# Output: 5->4->3->2->1->NULL
# Follow up:
# A linked list can be reversed either iteratively or recursively. Could you implement both?

# Definition for singly-linked list.


class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None


class Solution:
    def reverseList(self, head: ListNode) -> ListNode:
        h = head
        p = None
        while h:
            if p is None:
                p = ListNode(h.val)
                h = h.next
            else:
                temp = ListNode(h.val)
                temp.next = p
                p = temp
                h = h.next
        return p

    def reverseList1(self, head: ListNode) -> ListNode:
        if head is None:
            return None
        self.reverseUtil(head, None)
        return head

    def reverseUtil(self, curr, prev):

        # If last node mark it head
        if curr.next is None:
            self.head = curr

            # Update next to prev node
            curr.next = prev
            return

        # Save curr.next node for recursive call
        next = curr.next

        # And update next
        curr.next = prev

        self.reverseUtil(next, curr)

    def reverseList2(self, head: ListNode) -> ListNode:
        prev = None
        curr = head
        while curr is not None:
            next = curr.next
            curr.next = prev
            prev = curr
            curr = next
        return prev


def printNodes(h):
    while h:
        print(h.val, end="->")
        h = h.next


if __name__ == "__main__":
    h = ListNode(1)
    h.next = ListNode(2)
    h.next.next = ListNode(3)
    h.next.next.next = ListNode(4)
    h.next.next.next.next = ListNode(5)
    s = Solution()
    printNodes(s.reverseList2(h))
