#include <stdio.h>

// Definition for singly-linked list.
struct ListNode
{
    int val;
    struct ListNode *next;
};

struct ListNode *insertionSortList(struct ListNode *head)
{
    if (head == NULL || head->next == NULL)
    {
        return head;
    }
    struct ListNode *sortAns = NULL;
    while (head != NULL)
    {
        struct ListNode *pHead = head;
        struct ListNode **pp = &sortAns;
        head = head->next;
        while (*pp != NULL && pHead->val > (*pp)->val)
        {
            pp = &((*pp)->next);
        }
        pHead->next = *pp;
        *pp = pHead;
    }
    return sortAns;
}

void printList(struct ListNode *head)
{
    struct ListNode *tmp = head;
    while (tmp != NULL)
    {
        printf("%d -> ", tmp->val);
        tmp = tmp->next;
    }
}
int main()
{
    struct ListNode *head = &(struct ListNode{3, NUll});
    return 0;
}