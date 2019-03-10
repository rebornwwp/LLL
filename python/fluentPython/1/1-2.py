from math import hypot


class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __repr__(self):
        """
        __repr__ 方法返回的字符串应该是准确，无歧义的。
        __str__的区别在于，__str__ 是用str()函数的时候被使用，或者是print函数的时候调用str函数。str对
        终端用户友好。
        当无str函数的时候，解析器将会用repr替代。
        https://stackoverflow.com/questions/1436703/difference-between-str-and-repr  Alex Martelli
        """
        return 'Vector ({}, {})'.format(self.x, self.y)

    def __abs__(self):
        return hypot(self.x, self.y)

    def __bool__(self):
        return bool(abs(self))

    def __add__(self, other):
        x = self.x + other.x
        y = self.y + other.y
        return Vector(x, y)

    def __mul__(self, scale):
        x = self.x * scale
        y = self.y * scale
        return Vector(x, y)


a = Vector(1, 1)
b = Vector(2, 3)
print(a + b)
print(a * 2)
