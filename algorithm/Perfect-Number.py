# We define the Perfect Number is a positive integer that is equal to the sum of all its positive divisors except itself.

# Now, given an integer n, write a function that returns true when it is a perfect number and false when it is not.
# Example:
# Input: 28
# Output: True
# Explanation: 28 = 1 + 2 + 4 + 7 + 14
# Note: The input number n will not exceed 100,000,000. (1e8)


class Solution(object):
    def checkPerfectNumber(self, num):
        """
        :type num: int
        :rtype: bool
        """
        if num <= 1:
            return False
        n = 1
        i = 2
        while i <= num // i:
            if num % i == 0:
                d = num // i
                if d == i:
                    n = n + i
                else:
                    n = n + i + d
                if n > num:
                    return False
            i += 1
        return n == num


s = Solution()
print(s.checkPerfectNumber(28))
print(s.checkPerfectNumber(36))
print(s.checkPerfectNumber(10000000))
