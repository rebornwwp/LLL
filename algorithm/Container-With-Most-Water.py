class Solution:
    def maxArea(self, height):
        """
        :type height: List[int]
        :rtype: int
        """
        max_area = 0
        l, r = 0, len(height) - 1
        while l < r:
            max_area = max(max_area, min(height[l], height[r]) * (r - l))
            if height[l] > height[r]:
                r -= 1
            else:
                l += 1
        return max_area
