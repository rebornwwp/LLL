class Solution(object):
    def rotate(self, nums, k):
        """
        :type nums: List[int]
        :type k: int
        :rtype: void Do not return anything, modify nums in-place instead.
        """
        k = k % len(nums)
        l = nums[-k:] + nums[:-k]
        for i in range(len(l)):
            nums[i] = l[i]

    def rotate1(self, nums, k):
        l = nums[:]
        for i in range(len(l)):
            nums[(i + k) % len(l)] = l[i]


s = Solution()
l = [1, 2, 3, 4, 5, 6, 7]
k = 3
s.rotate1(l, k)
print(l)
