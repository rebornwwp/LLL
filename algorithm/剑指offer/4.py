# 用两个栈实现一个队列
# 题目描述
# 用两个栈来实现一个队列，完成队列的Push和Pop操作。 队列中的元素为int类型。


class Solution(object):
    stack1 = []
    stack2 = []

    def push(self, node):
        self.stack1.append(node)

    def pop(self):
        while self.stack1:
            self.stack2.append(self.stack1.pop())
        if self.stack2:
            result = self.stack2.pop()
            while self.stack2:
                self.stack1.append(self.stack2.pop())
        return result
