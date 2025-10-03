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

    def searchInsert1(self, nums, target):
        if nums[-1] < target:
            return len(nums)
        if nums[0] >= target:
            return 0
        return self.binary_find(nums, 0, len(nums) - 1, target)

    def binary_find(self, nums, i, j, target):
        mid = (i + j) // 2
        if nums[mid + 1] >= target and nums[mid] < target:
            return mid + 1
        elif nums[mid] < target:
            return self.binary_find(nums, mid + 1, j, target)
        elif nums[mid] >= target:
            return self.binary_find(nums, i, mid, target)


if __name__ == '__main__':
    solution = Solution()
    print(solution.searchInsert([1, 3, 5, 6], 2))
    print(solution.searchInsert1([1, 3, 5, 6], 2))
    print(solution.searchInsert1([1, 3], 2))
    print(solution.searchInsert1([1, 3, 5], 3))
