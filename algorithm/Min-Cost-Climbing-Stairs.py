#!/usr/bin/env python
# -*- coding:utf-8 -*-


class Solution:
    def minCostClimbingStairs(self, cost):
        """
        :type cost: List[int]
        :rtype: int
        """
        n = len(cost) + 1
        dp = [0] * n
        for i in range(2, n):
            dp[i] = min(cost[i-1]+dp[i-1], cost[i-2]+dp[i-2])
        return dp[-1]


def main():
    solution = Solution()
    cost = [1, 100, 1, 1, 1, 100, 1, 1, 100, 1]
    print(solution.minCostClimbingStairs(cost))


if __name__ == '__main__':
    main()
