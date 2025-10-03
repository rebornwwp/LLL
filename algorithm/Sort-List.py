# Sort a linked list in O(n log n) time using constant space complexity.

# Example 1:

# Input: 4->2->1->3
# Output: 1->2->3->4
# Example 2:

# Input: -1->5->3->4->0
# Output: -1->0->3->4->5


class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None


class Solution:
    def sortList(self, head: ListNode) -> ListNode:
        if head is None:
            return None
        a = []
        h = head
        while h:
            a.append(h)
            h = h.next
        a = sorted(a, key=lambda x: x.val)
        for i in range(len(a) - 1):
            a[i].next = a[i + 1]
        a[-1].next = None
        return a[0]

    def sortList1(self, head: ListNode) -> ListNode:
        if head is None or head.next is None:
            return head

        walker = head
        runner = head.next
        while runner is not None and runner.next is not None:
            walker = walker.next
            runner = runner.next.next

        mid = walker.next
        walker.next = None
        h = head

        left_list = self.sortList1(h)
        right_list = self.sortList1(mid)

        return self.merge(left_list, right_list)

    def merge(self, h1: ListNode, h2: ListNode) -> ListNode:
        h = ListNode(0)
        t = h
        while h1 and h2:
            if h1.val > h2.val:
                t.next = ListNode(h2.val)
                t = t.next
                h2 = h2.next
            else:
                t.next = ListNode(h1.val)
                t = t.next
                h1 = h1.next

        t.next = h1 if h1 is not None else h2

        return h.next

    def sortList2(self, head: ListNode) -> ListNode:
        """ quick sort
        """
        pass


def printList(l):
    while l:
        print(l.val, end="->")
        l = l.next
    print()


if __name__ == "__main__":
    l = ListNode(-1)
    l.next = ListNode(5)
    l.next.next = ListNode(3)
    l.next.next.next = ListNode(4)
    l.next.next.next.next = ListNode(0)

    sort_l = ListNode(0)
    sort_l.next = ListNode(2)
    sort_lr = ListNode(1)
    sort_lr.next = ListNode(10)
    s = Solution()
    printList(s.merge(sort_l, sort_lr))
    printList(l)
    printList(s.sortList1(l))
