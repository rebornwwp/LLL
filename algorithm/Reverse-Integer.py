# Given a 32-bit signed integer, reverse digits of an integer.
#
# Example 1:
#
# Input: 123
# Output: 321
#
# Example 2:
#
# Input: -123
# Output: -321
#
# Example 3:
#
# Input: 120
# Output: 21
#
# Note:
# Assume we are dealing with an environment which could only store integers within the 32-bit signed integer range: [−231,  231 − 1]. For the purpose of this problem, assume that your function returns 0 when the reversed integer overflows.


class Solution:
    def reverse(self, x):
        """
        :type x: int
        :rtype: int
        """
        sign = 1 if x > 0 else -1
        result = sign * int("".join(reversed(str(sign * x))))
        if result > 2**31 - 1 or result < -2**31:
            return 0
        return result


if __name__ == "__main__":
    s = Solution()
    print(s.reverse(123))
    print(s.reverse(-123))
    print(s.reverse(-120))
    print(s.reverse(12345678890888548375827))
