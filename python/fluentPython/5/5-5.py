# encoding=utf-8
import random

# 如果类定义了 __call__ 方法， 那么它的实例可以作为函数调用
# 类的实例可以表现的像函数


class BingoCage:
    def __init__(self, items):
        self._items = list(items)
        random.shuffle(self._items)

    def pick(self):
        try:
            return self._items.pop()
        except IndexError:
            raise LookupError('pick from empty bingoCage')

    def __call__(self):
        return self.pick()


bingo = BingoCage(range(10))

print(bingo())
print(bingo())
print(bingo())
print(bingo())
print(bingo())
print("callable instance of Class", callable(bingo))
