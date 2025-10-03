class Solution(object):
    def getRow(self, rowIndex):
        """
        :type rowIndex: int
        :rtype: List[int]
        """

        def helper(a, b):
            result = 1
            for i in range(a - b + 1, a + 1):
                result *= i
            for i in range(1, b + 1):
                result /= i
            return result

        result = []
        for i in range(rowIndex + 1):
            result.append(helper(rowIndex, i))
        return result


if __name__ == '__main__':
    solution = Solution()
    print(solution.getRow(3))
