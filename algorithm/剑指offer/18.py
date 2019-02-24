# 数组中出现次数超过一半的数字
# 题目描述
# 数组中有一个数字出现的次数超过数组长度的一半，请找出这个数字。
# 例如输入一个长度为9的数组{1,2,3,2,2,2,5,4,2}。由于数字2在
# 数组中出现了5次，超过数组长度的一半，因此输出2。如果不存在则
# 输出0。


class Solution:
    def MoreThanHalfNum_Solution(self, numbers):
        counter = {}
        for n in numbers:
            if n in counter:
                counter[n] += 1
            else:
                counter[n] = 1
            if counter[n] > len(numbers) // 2:
                return n
        return 0

    def MoreThanHalfNum_Solution1(self, numbers):
        sorted_numbers = sorted(numbers)
        mid = (0 + len(sorted_numbers)) // 2
        i = mid
        while i >= 0 and sorted_numbers[i] == sorted_numbers[mid]:
            i -= 1
        j = mid
        while j < len(sorted_numbers) and sorted_numbers[j] == sorted_numbers[mid]:
            j += 1
        if (j - i - 1) > (len(sorted_numbers) // 2):
            return sorted_numbers[mid]
        else:
            return 0

    def MoreThanHalfNum_Solution2(self, numbers):
        if len(numbers) == 0:
            return 0
        times = 0
        for n in numbers:
            if times == 0:
                prev = n
                times = 1
            elif n == prev:
                times += 1
            else:
                times -= 1
        if not self.checkMoreThanHalf(numbers, prev):
            return 0
        return prev

    def checkMoreThanHalf(self, numbers, num):
        return sum(map(lambda n: n == num, numbers)) > len(numbers) // 2

    def MoreThanHalfNum_Solution3(self, numbers):
        pass

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
    print(s.MoreThanHalfNum_Solution([1, 2, 3, 2, 2, 2, 5, 4, 2]))
    print(s.MoreThanHalfNum_Solution1([1, 2, 3, 2, 2, 2, 5, 4, 2]))
    print(s.MoreThanHalfNum_Solution2([1, 2, 3, 2, 2, 2, 5, 4, 2]))
    print(s.checkMoreThanHalf([1, 2, 2, 2, 3], 2))
    print(s.checkMoreThanHalf([1, 2, 2, 2], 2))
    print(s.checkMoreThanHalf([1, 2, 2, 2, 3], 3))
    l = [5, 7, 6, 5, 4, 3, 2, 1]
    print(s.partition(l, 0, 7))
    print(l)
