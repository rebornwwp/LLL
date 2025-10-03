class Solution(object):
    def pivotIndex(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        s = sum(nums)
        left_sum = 0
        for i, x in enumerate(nums):
            if left_sum == (s - left_sum - x):
                return i
            left_sum += x
        return -1


def main():
    nums = [-1, -1, -1, -1, -1, 0]
    solution = Solution()
    print(solution.pivotIndex(nums))


if __name__ == '__main__':
    main()
