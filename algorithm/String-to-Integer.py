class Solution:
    def myAtoi(self, str):
        """
        :type str: str
        :rtype: int
        """
        str = str.strip().replace(' ', '')
        i = 0
        base = 10
        sign = 1
        length = len(str)
        result = 0
        while i < length and str[i] in '+-':
            if str[i] == '-':
                sign *= -1
            elif str[i] == '+':
                sign *= 1
            i += 1

        while i < length and str[i].isdigit():
            result = result * base + int(str[i])
            i += 1
        return result * sign


def main():
    solution = Solution()
    str = '+----+123456789'
    print(solution.myAtoi(str))


if __name__ == '__main__':
    main()
