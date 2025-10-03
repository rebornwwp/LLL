# 最小的k个数
# 题目描述
# 输入n个整数，找出其中最小的K个数。例如输入
# 4,5,1,6,2,7,3,8这8个数字，则最小的4个数
# 字是1,2,3,4


class Solution:
    def GetLeastNumbers_Solution(self, tinput, k):
        l = sorted(tinput)
        if k > len(tinput):
            return []
        return l[0:k]

    def GetLeastNumbers_Solution1(self, tinput, k):
        if len(tinput) == 0:
            return []
        if k > len(tinput):
            return []
        start = 0
        end = len(tinput) - 1
        index = self.partition(tinput, start, end)
        while index != k - 1:
            if index > k - 1:
                end = index - 1
                index = self.partition(tinput, start, end)
            if index < k - 1:
                start = index + 1
                index = self.partition(tinput, start, end)
        return sorted(tinput[0:k])

    def GetLeastNumbers_Solution2(self, tinput, k):
        if len(tinput) == 0 or len(tinput) < k or k == 0:
            return []
        results = []
        for i in tinput:
            if len(results) < k:
                results.append(i)
            else:
                index = self.index_of_max(results)
                if results[index] > i:
                    results[index] = i
        return sorted(results)

    def index_of_max(self, l):
        max_index = None
        for i in range(len(l)):
            if max_index is None:
                max_index = i
            elif l[max_index] < l[i]:
                max_index = i
        return max_index

    def partition(self, numbers, start, end):
        temp = start
        start += 1
        while start < end:
            if numbers[start] < numbers[temp]:
                start += 1
            if numbers[end] >= numbers[temp]:
                end -= 1
            if numbers[end] < numbers[temp] <= numbers[start]:
                numbers[end], numbers[start] = numbers[start], numbers[end]
                start += 1
                end -= 1
        numbers[end], numbers[temp] = numbers[temp], numbers[end]
        return end


if __name__ == "__main__":
    s = Solution()
    l = [4, 5, 1, 6, 2, 7, 3, 8]
    print(s.GetLeastNumbers_Solution2(l, 2))
