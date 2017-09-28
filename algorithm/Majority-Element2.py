# more than ⌊ n/2 ⌋ times. 说是一定这样，那等于说个数肯定比其他元素多，
# 这样对象就是两个，比较这两个就好了
class Solution(object):
    def majorityElement(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        majority, counter = nums[0], 1
        for num in nums[1:]:
            if counter:
                counter = 1
                majority = num
            elif num == majority:
                counter += 1
            else:
                counter -= 1
        return majority
