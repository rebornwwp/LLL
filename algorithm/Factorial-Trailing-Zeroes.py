ass Solution(object):
    def trailingZeroes(self, n):
        """
        :type n: int
        :rtype: int
        """
        rest = 0
        while n:
            rest += (n /= 5)
        return rest
