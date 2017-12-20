class Solution(object):
    def thirdMax(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        sorted_nums = sorted(list(set(nums)), reverse=True)
        return sorted_nums[2] if len(sorted_nums) >= 3 else sorted_nums[0]


def main():
    solution = Solution()
    l = [3, 2, 1]
    print(solution.thirdMax(l))


if __name__ == '__main__':
    main()
