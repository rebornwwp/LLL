# 矩阵覆盖
# 题目描述
# 我们可以用2*1的小矩形横着或者竖着
# 去覆盖更大的矩形。请问用n个2*1的
# 小矩形无重叠地覆盖一个2*n的大矩形，
# 总共有多少种方法？


class Solution:
    def rectCover(self, n):
        if n == 0:
            return 0
        if n == 1:
            return 1
        if n == 2:
            return 2
        a, b = 1, 2
        for _ in range(3, n + 1):
            a, b = b, a + b
        return b
