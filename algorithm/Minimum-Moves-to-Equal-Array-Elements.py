# encoding=utf8
# Given a non-empty integer array of size n, find the minimum number of moves required to make all array elements equal, where a move is incrementing n - 1 elements by 1.

# Example:

# Input:
# [1,2,3]

# Output:
# 3

# Explanation:
# Only three moves are needed (remember each move increments two elements):

# [1,2,3]  =>  [2,3,3]  =>  [3,4,3]  =>  [4,4,4]


class Solution(object):
    def minMoves(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        i = 0
        while True:
            if all(v == nums[0] for v in nums):
                return i
            nums = sorted(nums)
            nums = [x + 1 for x in nums[0: -1]] + nums[-1:]
            i += 1

    def minMoves1(self, nums):
        return sum(nums) - min(nums) * len(nums)


s = Solution()
print(s.minMoves1([1, 2147483647]))
