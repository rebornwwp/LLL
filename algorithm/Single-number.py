class Solution(object):
    def singleNumber(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        result = 0
        for num in nums:
            result ^= num
        return result


if __name__ == '__main__':
    solution = Solution()
    nums = [1, 2, 3, 2, 1]
    result = solution.singleNumber(nums)
    print(result)
