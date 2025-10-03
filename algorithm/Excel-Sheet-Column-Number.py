class Solution(object):
    def titleToNumber(self, s):
        """
        :type s: str
        :rtype: int
        """
        return 0 if s == '' else (self.titleToNumber(s[:-1]) * 26 + ord(s[-1]) - ord('A') + 1)

if __name__ == "__main__":
    solution = Solution()
    print(solution.titleToNumber('AA'))
