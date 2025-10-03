class MinStack(object):

    def __init__(self):
        """
        initialize your data structure here.
        """
        self.stack = []
        self.min = None

    def push(self, x):
        """
        :type x: int
        :rtype: void
        """
        if not self.stack:
            self.stack.append(0)
            self.min = x
        else:
            self.stack.append(x - self.min)
            if x < self.min:
                self.min = x

    def pop(self):
        """
        :rtype: void
        """
        x = self.stack.pop()
        if x < 0:
            self.min = self.min - x

    def top(self):
        """
        :rtype: int
        """
        x = self.stack[-1]
        if x > 0:
            return self.min + x
        else:
            return self.min

    def getMin(self):
        """
        :rtype: int
        """
        return self.min


class MinStack1:

    def __init__(self):
        """
        initialize your data structure here.
        """
        self.stack = []
        self.min_stack = []

    def push(self, x: int) -> None:
        self.stack.append(x)
        if len(self.min_stack) == 0:
            self.min_stack.append(x)
        else:
            last = self.min_stack[-1]
            if last > x:
                self.min_stack.append(x)
            else:
                self.min_stack.append(last)

    def pop(self) -> None:
        if len(self.stack) == 0:
            raise IndexError("pop from empty min stack")

        self.min_stack.pop()

        result = self.stack.pop()
        return result

    def top(self) -> int:
        return self.stack[-1]

    def getMin(self) -> int:
        return self.min_stack[-1]


if __name__ == "__main__":
    # Your MinStack object will be instantiated and called as such:
    obj = MinStack()
    obj.push(-2)
    obj.push(0)
    obj.push(-3)
    print(obj.getMin())
    obj.pop()
    print(obj.top())
    print(obj.getMin())
