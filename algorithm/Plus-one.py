class Solution(object):
    def plusOne(self, digits):
        """
        :type digits: List[int]
        :rtype: List[int]
        """
        digits[-1] = digits[-1] + 1
        reversed_digits = list(reversed(digits))
        carry = 0
        for i in range(len(reversed_digits)):
            sum_i = reversed_digits[i] + carry
            carry, reversed_digits[i] = divmod(sum_i, 10)
        if carry == 1:
            reversed_digits.append(1)
        return list(reversed(reversed_digits))


if __name__ == '__main__':
    solution = Solution()
    a = [1, 2, 3, 9]
    b = solution.plusOne(a)
    print(b)
