class Solution(object):
    def maximumProduct(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        nums.sort()
        return max(nums[0] * nums[1] * nums[len(nums) - 1], nums[len(nums) - 1] * nums[len(nums) - 2] * nums[len(nums) - 3])


def main():
    l = [-1, -2, -4, -5]
    solution = Solution()
    print(solution.maximumProduct(l))


if __name__ == '__main__':
    main()
