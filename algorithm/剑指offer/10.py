# 连续子数组的最大和
# 题目描述
# HZ偶尔会拿些专业问题来忽悠那些非计算机专业的同学。
# 今天测试组开完会后,他又发话了:在古老的一维模式识别
# 中,常常需要计算连续子向量的最大和,当向量全为正数的
# 时候,问题很好解决。但是,如果向量中包含负数,是否应
# 该包含某个负数,并期望旁边的正数会弥补它呢？例如:
# {6,-3,-2,7,-15,1,2,2},连续子向量的最大和为8
# (从第0个开始,到第3个为止)。给一个数组，返回它的
# 最大连续子序列的和，你会不会被他忽悠住？(子向量的
# 长度至少是1)


class Solution:
    def FindGreatestSumOfSubArray(self, array):
        max = array[0]
        sum = 0
        for i in array:
            sum = sum + i
            if sum > max:
                max = sum
            elif sum < 0:
                sum = 0
        return max
