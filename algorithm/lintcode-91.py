# 描述
# 中文
# English
# Given an integer array, adjust each integers so that the difference of every adjacent integers are not greater than a given number target.
#
# If the array before adjustment is A, the array after adjustment is B, you should minimize the sum of |A[i]-B[i]|
#
# You can assume each number in the array is a positive integer and not greater than 100.
#
# 样例
# Example 1:
# Input:  [1,4,2,3], target=1
# Output:  2
#
# Example 2:
# Input:  [3,5,4,7], target=2
# Output:  1
#


class Solution:
    """
    @param: A: An integer array
    @param: target: An integer
    @return: An integer
    """
    def MinAdjustmentCost(self, A, target):
        import sys
        dp = [[sys.maxsize for _ in range(101)] for _ in range(len(A)+1)]

        for i in range(101):
            dp[0][i] = 0

        for i in range(1, len(A)+1):
            for j in range(101):
                for k in range(101):
                    if abs(j-k) <= target:
                        dp[i][j] = min(dp[i][j], dp[i-1][k]+abs(A[i-1]-j))

        min_cost = sys.maxsize
        for i in range(101):
            min_cost = min(min_cost, dp[len(A)][i])
        return min_cost