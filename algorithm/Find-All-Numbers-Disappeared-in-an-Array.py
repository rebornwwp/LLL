#!/usr/bin/env python
# -*- coding:utf-8 -*-


class Solution:
    def findDisappearedNumbers(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        i = 0
        while i < len(nums):
            tmp = nums[i] - 1
            if nums[i] == 0 or nums[tmp] == 0:
                i += 1
            else:
                nums[i], nums[tmp] = nums[tmp], 0

        result = []
        for i, num in enumerate(nums):
            if num != 0:
                result.append(i+1)
        return result


def main():
    solutin = Solution()
    a = [4, 3, 2, 7, 8, 2, 3, 1]
    print(solutin.findDisappearedNumbers(a))


if __name__ == '__main__':
    main()
