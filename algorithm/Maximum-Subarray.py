class Solution(object):
    def maxSubArray(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        l = g = -10000000000
        for n in nums:
            l = max(n, l + n)
            g = max(l, g)
        return g

    def maxSubArray1(self, nums):
        if not nums:
            return
        max_num = None
        acc_sum = 0
        for n in nums:
            if acc_sum <= 0:
                acc_sum = n
            else:
                acc_sum += n
            if max_num is None:
                max_num = acc_sum
            elif acc_sum > max_num:
                max_num = acc_sum
        return max_num

    def maxSubArray2(self, nums):
        if not nums:
            return
        f = [0] * len(nums)
        for i in range(len(nums)):
            if i == 0 or f[i - 1] <= 0:
                f[i] = nums[i]
            elif i != 0 and f[i - 1] > 0:
                f[i] = f[i - 1] + nums[i]
        return max(f)

    def maxSubArray3(self, nums):
        for i in range(1, len(nums)):
            if nums[i - 1] > 0:
                nums[i] += nums[i - 1]
        return max(nums)


if __name__ == "__main__":
    l = [1, -2, 3, 10, -4, 7, 2, -5]
    s = Solution()
    print(s.maxSubArray3(l))
    print(s.maxSubArray3([-2, 1, -3, 4, -1, 2, 1, -5, 4]))
