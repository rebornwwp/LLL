# Given two non-negative integers num1 and num2 represented as strings, return the product of num1 and num2, also represented as a string.

# Example 1:

# Input: num1 = "2", num2 = "3"
# Output: "6"
# Example 2:

# Input: num1 = "123", num2 = "456"
# Output: "56088"
# Note:

# The length of both num1 and num2 is < 110.
# Both num1 and num2 contain only digits 0-9.
# Both num1 and num2 do not contain any leading zero, except the number 0 itself.
# You must not use any built-in BigInteger library or convert the inputs to integer directly.


class Solution(object):
    def multiply(self, num1, num2):
        """
        :type num1: str
        :type num2: str
        :rtype: str
        """
        n = len(num1) + 1 + len(num2)
        ans = [0] * n
        reverse_num1 = num1[::-1]
        reverse_num2 = num2[::-1]
        for i in range(len(num1)):
            curry = 0
            for j in range(len(num2)):
                mod = (
                    int(reverse_num1[i]) * int(reverse_num2[j]) + curry + ans[i + j]) % 10
                curry = (
                    int(reverse_num1[i]) * int(reverse_num2[j]) + curry + ans[i + j]) // 10
                ans[i+j] = mod
            ans[i + j + 1] = curry
        ans = ans[::-1]
        for i in range(len(ans)):
            if ans[i] != 0:
                break
        return ''.join(str(x) for x in ans[i:])


s = Solution()
num1 = "2"
num2 = "3"
print(s.multiply(num1, num2))
