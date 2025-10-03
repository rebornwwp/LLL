class Solution(object):
    def missingNumber(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        l = [False for _ in range(len(nums) + 1)]
        for i in nums:
            l[i] = True

        return l.index(False)


def main():
    solution = Solution()
    l = [3, 0, 1]
    print(solution.missingNumber(l))


if __name__ == '__main__':
    main()
