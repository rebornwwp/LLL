class Solution(object):
    def majorityElement(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        import collections
        counter = collections.Counter(nums)
        length = len(nums)
        for key in counter:
            if counter[key] > length // 2:
                return key

    def majorityElement1(self, nums: List[int]) -> int:
        num = nums[0]
        times = 1
        for n in nums[1:]:
            if times == 0:
                num = n
                times = 1
            elif num == n:
                times += 1
            else:
                times -= 1

        return num
