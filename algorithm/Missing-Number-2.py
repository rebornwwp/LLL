class Solution(object):
    def missingNumber(self, nums):
        """ 高斯求和法
         :type nums: List[int]
         :rtype: int
        """
        actual_sum = sum(nums)
        gaosi_sum = sum([i for i in range(len(nums) + 1)])
        return gaosi_sum - actual_sum


def main():
    solution = Solution()
    l = [3, 2, 1]
    print(solution.missingNumber(l))


if __name__ == '__main__':
    main()
