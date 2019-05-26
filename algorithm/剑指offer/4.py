# 用两个栈实现一个队列
# 题目描述
# 用两个栈来实现一个队列，完成队列的Push和Pop操作。 队列中的元素为int类型。


class Solution(object):
    def __init__(self):
        self.stack1 = []
        self.stack2 = []

    def push(self, node):
        """
        :param node: int
        :return: int
        """
        self.stack1.append(node)

    def pop(self):
        """
        :return: int
        """
        result = self.top()
        self.stack2.pop()
        return result

    def top(self):
        """
        :return: int
        """
        if not self.stack2:
            while self.stack1:
                self.stack2.append(self.stack1.pop())
        result = self.stack2[-1]
        return result
