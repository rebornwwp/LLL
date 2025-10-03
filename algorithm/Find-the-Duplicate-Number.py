class Solution(object):
    def findDuplicate(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        nums.sort()
        for i in range(len(nums) - 1):
            if nums[i] == nums[i + 1]:
                return nums[i]

    def findDuplicate2(self, nums):
        seen = set()
        for num in nums:
            if num in seen:
                return num
            else:
                seen.add(num)

    def findDuplicate3(self, nums):
        tortoise = nums[0]
        hare = nums[0]
        while True:
            tortoise = nums[tortoise]
            hare = nums[nums[hare]]
            if tortoise == hare:
                break

        ptr1 = nums[0]
        ptr2 = hare
        while ptr1 != ptr2:
            ptr1 = nums[ptr1]
            ptr2 = nums[ptr2]
        return ptr1


def main():
    solution = Solution()
    l = [3, 2, 1, 1]
    print(solution.findDuplicate(l))


if __name__ == '__main__':
    main()
