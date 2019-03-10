class Solution(object):
    def moveZeroes(self, nums):
        """
        :type nums: List[int]
        :rtype: void Do not return anything, modify nums in-place instead.
        """
        index = 0
        for i in range(len(nums)):
            if nums[i] != 0:
                nums[index] = nums[i]
                index += 1
        while index < len(nums):
            nums[index] = 0
            index += 1

    def moveZeroes1(self, nums):
        """
        :type nums: List[int]
        :rtype: None Do not return anything, modify nums in-place instead.
        """
        i = 0
        j = 0
        length = len(nums)
        while i < length:
            # find 0 index
            while j < length and nums[j] != 0:
                j += 1
            # find not 0 index
            while i < length and nums[i] == 0:
                i += 1
            if i > j and i < length:
                nums[i], nums[j] = nums[j], nums[i]
            if i < j:
                # 跳过指向的非0数
                i += 1
            if i >= length or j >= length:
                return nums


def main():
    solution = Solution()
    nums = [0, 1, 0, 3, 12]
    solution.moveZeroes(nums)
    print(nums)


if __name__ == '__main__':
    main()
