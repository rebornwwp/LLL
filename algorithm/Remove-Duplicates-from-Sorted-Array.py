class Solution(object):
    def removeDuplicates(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        if len(nums) <= 1:
            return len(nums)
        result_ind = 0
        for i in range(1, len(nums)):
            if nums[i] != nums[result_ind]:
                result_ind += 1
                nums[result_ind] = nums[i]
        return result_ind + 1


if __name__ == '__main__':
    solution = Solution()
    print(solution.removeDuplicates([1,1,3,4]))

    print(solution.removeDuplicates([1,1,2]))
