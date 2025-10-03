class Solution(object):
    def reverseStr(self, s, k):
        """
        :type s: str
        :type k: int
        :rtype: str
        """
        result = ''
        i = 0
        isreversed = 0
        while i < len(s):
            if i + k < len(s):
                if isreversed % 2 == 0:
                    result += ''.join(list(reversed(s[i:i + k])))
                    i = i + k
                    isreversed += 1
                elif isreversed % 2 == 1:
                    result += s[i:i + k]
                    i = i + k
                    isreversed += 1
            else:
                if isreversed % 2 == 0:
                    result += ''.join(list(reversed(s[i:len(s)])))
                    i = i + k
                else:
                    result += s[i:i + k]
                    i = i + k
        return result


if __name__ == '__main__':
    solution = Solution()
    a = 'abcdefg'
    print(solution.reverseStr(a, 2))
