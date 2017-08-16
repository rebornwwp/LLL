class Solution(object):
    def climbStairs(self, n):
        """
        :type n: int
        :rtype: int
        """
        if n <= 0:
            return 0
        if n == 1:
            return 1
        if n == 2:
            return 2
        p_v = 1
        result = 2
        for i in range(2, n):
            result, p_v, pp_v = result + p_v, result, p_v
        return result


if __name__ == '__main__':
    solution = Solution()
    result = solution.climbStairs(36)
    print(result)
