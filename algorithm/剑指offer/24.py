# 数值的整数次方
# 题目描述
# 给定一个double类型的浮点数base和int类型的整数exponent。求base的exponent次方。


class Solution:
    def Power(self, base, exponent):
        if base < 0.0000001 and base > -0.0000001:
            return 0
        else:
            if exponent == 0:
                return 1
            elif exponent > 0:
                ans = 1.0
                for i in range(0, exponent):
                    ans = ans * base
                return ans
            else:
                loop = abs(exponent)
                ans = 1.0
                for i in range(0, loop):
                    ans = ans * base
                ans = 1 / ans
                return ans
