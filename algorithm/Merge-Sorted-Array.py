class Solution(object):
    def merge(self, nums1, m, nums2, n):
        """
        :type nums1: List[int]
        :type m: int
        :type nums2: List[int]
        :type n: int
        :rtype: void Do not return anything, modify nums1 in-place instead.
        """
        new_nums = nums1[:m] + nums2[:n]
        new_nums.sort()
        for _ in range(len(nums1) - m - n):
            nums1.pop()
        for i in range(len(nums1)):
            nums1[i] = new_nums[i]


if __name__ == '__main__':
    solution = Solution()
    nums1 = [1,3,5,7,9,11,13,15]
    solution.merge(nums1, 4, [2,4,6,8,10], 3)
    print(nums1)
