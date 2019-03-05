# Given a singly linked list, determine if it is a palindrome.

# Example 1:

# Input: 1->2
# Output: false
# Example 2:

# Input: 1->2->2->1
# Output: true
# Follow up:
# Could you do it in O(n) time and O(1) space?


class ListNode:
    def __init__(self, x):
        self.val = x
        self.next = None


class Solution:
    def isPalindrome(self, head: ListNode) -> bool:
        a = []
        h = head
        while h:
            a.append(h.val)
            h = h.next

        return a == a[::-1]

    def isPalindrome1(self, head: ListNode) -> bool:
        if not head:
            return True

        # get mid node of link
        slower = head
        faster = head.next
        while faster and faster.next:
            slower = slower.next
            faster = faster.next.next

        mid = slower.next
        slower.next = None

        # reverse nodes of after the mid
        pre = None
        while mid:
            next = mid.next
            mid.next = pre
            pre = mid
            mid = next

        # check equality
        h = head
        while pre and h:
            if pre.val != h.val:
                return False
            pre = pre.next
            h = h.next
        return True

    def printNodes(self, h):
        while h:
            print(h.val, end="->")
            h = h.next
        print()


if __name__ == "__main__":
    h = ListNode(1)
    h.next = ListNode(2)
    h.next.next = ListNode(3)
    h.next.next.next = ListNode(2)
    h.next.next.next.next = ListNode(1)
    s = Solution()
    print(s.isPalindrome1(h))
