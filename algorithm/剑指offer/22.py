# 包含min函数的栈
# 题目描述
# 定义栈的数据结构，请在该类型中实现一个能够得到
# 栈中所含最小元素的min函数（时间复杂度应为O（1））。


class Solution:

    l = []
    min_stack = []

    def push(self, node):
        self.l.append(node)
        if len(self.min_stack) == 0:
            self.min_stack.append(node)
        else:
            last = self.min_stack[-1]
            if last > node:
                self.min_stack.append(node)
            else:
                self.min_stack.append(last)

    def pop(self):
        results = self.l.pop()
        self.min_stack.pop()
        return results

    def top(self):
        return self.l[-1]

    def min(self):
        return self.min_stack[-1]
