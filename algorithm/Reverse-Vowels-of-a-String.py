class Solution(object):
    def reverseVowels(self, s):
        """
        :type s: str
        :rtype: str
        """
        vowels = 'aeiouAEIOU'
        if len(s) < 2:
            return s
        s = list(s)
        start = 0
        end = len(s) - 1
        while start <= end:
            while start <= end and s[start] not in vowels:
                start += 1
            while start <= end and s[end] not in vowels:
                end -= 1
            if start <= end:
                s[start], s[end] = s[end], s[start]
            start += 1
            end -= 1
        return ''.join(s)


if __name__ == '__main__':
    s = "leetcode"
    solution = Solution()
    print(solution.reverseVowels(s))
