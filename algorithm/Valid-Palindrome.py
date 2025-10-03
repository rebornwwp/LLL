class Solution(object):
    def isPalindrome(self, s):
        """
        :type s: str
        :rtype: bool
        """
        palindrome = ''
        for i in s:
            if i.isalnum():
                palindrome += i.lower()
        return palindrome == palindrome[::-1]


# 溢出
if __name__ == '__main__':
    a = 'A man, a plan, a canal: Panama'
    solution = Solution()
    print(solution.isPalindrome(a))
