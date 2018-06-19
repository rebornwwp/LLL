#!/usr/bin/env python
# -*- coding:utf-8 -*-


class Solution:
    def findMaxAverage(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: float
        first_value = nums[0] + nums[1] + nums[2] + nums[3]
        next_value  = nums[1] + nums[2] + nums[3] + nums[4]
        So next_value  = first_value - nums[0] + nums[4]
        """
        max_value = sum(nums[0:k])
        some_value = max_value
        for i in range(1, len(nums) - k + 1):
            some_value = some_value - nums[i-1] + nums[i-1+k]
            max_value = max(max_value, some_value)
        return max_value / k


def main():
    solution = Solution()
    l = [1, 12, -5, -6, 50, 3]
    k = 4
    print(solution.findMaxAverage(l, k))


if __name__ == '__main__':
    main()
