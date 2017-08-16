class Solution(object):
    def climbStairs(self, n):
        """
        :type n: int
        :rtype: int
        """
        if n in [0, 1]:
            return 1
        return self.climbStairs(n - 1) + self.climbStairs(n - 2)

# 溢出
if __name__ == '__main__':
    solution = Solution()
    result = solution.climbStairs(36)
    print(result)
