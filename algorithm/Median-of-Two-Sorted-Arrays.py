class Solution(object):
    def findMedianSortedArrays(self, nums1, nums2):
        """
        :type nums1: List[int]
        :type nums2: List[int]
        :rtype: float
        """
        length = len(nums1) + len(nums2)
        merge_arr = []
        i = j = 0
        while i < len(nums1) and j < len(nums2):
            if nums1[i] < nums2[j]:
                merge_arr.append(nums1[i])
                i += 1
            else:
                merge_arr.append(nums2[j])
                j += 1

        while i < len(nums1):
            merge_arr.append(nums1[i])
            i += 1

        while j < len(nums2):
            merge_arr.append(nums2[j])
            j += 1

        if length & 1 == 0:
            return float((merge_arr[length // 2] + merge_arr[length // 2 - 1]) / 2)
        else:
            return float(merge_arr[length // 2])


def main():
    solution = Solution()
    nums1 = [1, 2]
    nums2 = [3, 4]
    print(solution.findMedianSortedArrays(nums1, nums2))


if __name__ == '__main__':
    main()
