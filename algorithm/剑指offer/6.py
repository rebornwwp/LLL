# 斐波那契数列
# 题目描述
# 大家都知道斐波那契数列，现在要求输入
# 一个整数n，请你输出斐波那契数列的
# 第n项（从0开始，第0项为0）。
# n<=39


class Solution:
    def Fibonacci(self, n):
        if n == 0:
            return 0
        if n == 1:
            return 1
        a, b = 0, 1
        for _ in range(2, n + 1):
            a, b = b, a + b
        return b
