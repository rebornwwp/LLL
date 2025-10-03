# 跳台阶
# 问题描述
# 一只青蛙一次可以跳上1级台阶，也可以跳上2级。
# 求该青蛙跳上一个n级的台阶总共有多少种跳法(先后次序不同算不同的结果)


class Solution:
    def jumpFloor(self, n):
        if n == 0:
            return 0
        if n == 1:
            return 1
        if n == 2:
            return 2
        a, b = 1, 2,
        for _ in range(3, n + 1):
            a, b = b, a + b
        return b
