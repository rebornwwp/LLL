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
