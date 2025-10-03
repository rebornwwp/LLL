class Solution(object):
    def climbStairs(self, n):
        """
        :type n: int
        :rtype: int
        """
        if n in [0, 1]:
            return 1
        return self.climbStairs(n - 1) + self.climbStairs(n - 2)

    def climbStairs1(self, n):
        """
        :type: n: int
        :rtype: int
        """
        mem = {0: 1, 1: 1}
        for i in range(n + 1):
            if i not in mem:
                mem[i] = mem[i - 1] + mem[i - 2]
        return mem[n]


# 溢出
if __name__ == '__main__':
    solution = Solution()
    result = solution.climbStairs(36)
    result1 = solution.climbStairs1(36)
    print(result)
    print(result1)
