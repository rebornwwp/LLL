class Solution(object):
    def addBinary(self, a, b):
        """
        :type a: str
        :type b: str
        :rtype: str
        """
        carry = 0
        result = []
        a = list(reversed(a))
        b = list(reversed(b))
        min_len = min(len(a), len(b))
        for i in range(min_len):
            sum_i = int(a[i]) + int(b[i]) + carry
            carry, mod = divmod(sum_i, 2)
            result.insert(0, str(mod))

        i += 1
        if len(a) > i:
            while i < len(a):
                sum_i = int(a[i]) + carry
                carry, mod = divmod(sum_i, 2)
                result.insert(0, str(mod))
                i += 1
        if len(b) > i:
            while i < len(b):
                sum_i = int(b[i]) + carry
                carry, mod = divmod(sum_i, 2)
                result.insert(0, str(mod))
                i += 1
        if carry == 1:
            result.insert(0, str(carry))
        return ''.join(result)


if __name__ == '__main__':
    solution = Solution()
    a = '111'
    b = '1'
    print(solution.addBinary(a, b))
