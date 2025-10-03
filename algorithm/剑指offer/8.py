# 变态跳台阶
# 题目描述
# 一只青蛙一次可以跳上1级台阶，也可以跳上2级……
# 它也可以跳上n级。求该青蛙跳上一个n级的台阶总
# 共有多少种跳法。


class Solution:
    def jumpFloorII(self, n):
        if n == 0:
            return 0
        if n == 1:
            return 1
        f = 1
        for _ in range(2, n + 1):
            f = f * 2
        return f
