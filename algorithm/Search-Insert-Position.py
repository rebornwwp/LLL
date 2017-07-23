class Solution(object):
    def searchInsert(self, nums, target):
        """
        :type nums: List[int]
        :type target: int
        :rtype: int
        """
        if nums[-1] < target:
            return len(nums)
        for i in range(len(nums)):
            if nums[i] >= target:
                return i


if __name__ == '__main__':
    solution = Solution()
    print(solution.searchInsert([1,2,4], 3))
