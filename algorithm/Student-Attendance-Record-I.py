class Solution(object):
    def checkRecord(self, s):
        """
        :type s: str
        :rtype: bool
        """
        if s.count('A') > 1:
            return False
        if 'LLL' in s:
            return False
        return True


if __name__ == '__main__':
    solution = Solution()
    a = 'LALL'
    print(solution.checkRecord(a))
