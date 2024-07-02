
// Definition for singly-linked list.
struct ListNode {
  int val;
  ListNode *next;
  ListNode() : val(0), next(nullptr) {}
  ListNode(int x) : val(x), next(nullptr) {}
  ListNode(int x, ListNode *next) : val(x), next(next) {}
};

class Solution {
 public:
  ListNode *addTwoNumbers(ListNode *l1, ListNode *l2) {
    if (l1 == nullptr) {
      return l1;
    }
    if (l2 == nullptr) {
      return l2;
    }

    ListNode result{};
    ListNode *ref = &result;
    int res = 0;
    while (l1 != nullptr || l2 != nullptr) {
      if (l1 != nullptr) {
        res += l1->val;
        l1 = l1->next;
      }
      if (l2 != nullptr) {
        res += l2->val;
        l2 = l2->next;
      }
      ref->next = new ListNode(res % 10);
      ref = ref->next;
      res = res / 10;
    }

    if (res != 0) {
      ref->next = new ListNode(res);
    }

    return result.next;
  }
};