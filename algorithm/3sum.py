# Given an array nums of n integers, are there elements a, b, c in nums such that a + b + c = 0? Find all unique triplets in the array which gives the sum of zero.
# Note:
# The solution set must not contain duplicate triplets.
# Example:
# Given array nums = [-1, 0, 1, 2, -1, -4],
# A solution set is:
# [
#   [-1, 0, 1],
#   [-1, -1, 2]
# ]


class Solution:
    def threeSum(self, nums):
        """
        :type nums: List[int]
        :rtype: List[List[int]]
        """
        import itertools
        result = []
        for i in range(1, len(nums)):
            result = result + self.twoSum(nums, i, len(nums), -nums[i - 1])
        result = [sorted([nums[x], nums[y], nums[z]]) for (x, y, z) in result]
        new_num = [num for num, _ in itertools.groupby(sorted(result))]
        return new_num

    def twoSum(self, nums, begin, end, target):
        result = []
        d = {}
        for i in range(begin, end):
            if nums[i] in d:
                a = begin - 1
                b = d[nums[i]]
                c = i
                result.append([a, b, c])
            d[target - nums[i]] = i
        return result

    def threeSum1(self, nums):
        result = []
        if len(nums) < 3:
            return result

        nums = sorted(nums)
        for i in range(len(nums) - 2):
            if i == 0 or nums[i] > nums[i - 1]:
                j = i + 1
                k = len(nums) - 1
                while (j < k):
                    if nums[i] + nums[j] + nums[k] == 0:
                        result.append([nums[i], nums[j], nums[k]])
                        j += 1
                        k -= 1
                        while j < k and nums[j] == nums[j - 1]:
                            j += 1
                        while j < k and nums[k] == nums[k + 1]:
                            k -= 1
                    elif nums[i] + nums[j] + nums[k] < 0:
                        j += 1
                    else:
                        k -= 1
        return result

    def threeSum2(self, nums):
        """
        转化成一个更加精简的结构来存储数据
        """
        counter = {}
        for num in nums:
            counter[num] = counter.get(num, 0) + 1
        if counter.get(0, 0) > 2:
            result = [[0, 0, 0]]
        else:
            result = []

        positive = sorted([num for num in counter if num >= 0])
        negitive = sorted([num for num in counter if num < 0])
        for i in negitive:
            for j in positive:
                mid = -i - j
                if mid in counter:
                    if mid in (i, j) and counter[mid] > 1:
                        result.append([i, mid, j])
                    elif mid > i and mid < j:
                        result.append([i, mid, j])
        return result


if __name__ == "__main__":
    s = Solution()
    print(s.threeSum2([-1, 0, 1, 2, -1, -4]))
