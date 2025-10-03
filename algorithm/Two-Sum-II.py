class Solution(object):
    def twoSum(self, numbers, target):
        """
        :type numbers: List[int]
        :type target: int
        :rtype: List[int]
        """
        for i in range(len(numbers)):
            j = self.binary_search(numbers, i+1, len(numbers)-1, target-numbers[i])
            if j is not None:
                return [i+1, j+1]

    def binary_search(self, numbers, start, end, num):
        mid = (start + end) // 2
        if start <= end:
            if numbers[mid] == num:
                return mid
            elif numbers[mid] < num:
                return self.binary_search(numbers, mid+1, end, num)
            else:
                return self.binary_search(numbers, start, mid-1, num)
        return None


if __name__ == "__main__":
    l = [5, 25, 75]
    solution = Solution()
    print(solution.twoSum(l, 100))
