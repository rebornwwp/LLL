# http://baike.baidu.com/item/%E7%BD%97%E9%A9%AC%E6%95%B0%E5%AD%97
class Solution(object):
    def romanToInt(self, s):
        """
        :type s: str
        :rtype: int
        """
        integerDict = {'I': 1, 'V': 5, 'X': 10, 'L': 50, 'C': 100, 'D': 500, 'M': 1000}
        result = 0
        for i in range(len(s)):
            if i + 1 < len(s) and integerDict[s[i]] < integerDict[s[i+1]]:
                result -= integerDict[s[i]]
            else:
                result += integerDict[s[i]]
        return result


if __name__ == '__main__':
    solution = Solution()
    print(solution.romanToInt('XLV'))
    print(solution.romanToInt('XX'))
    print(solution.romanToInt('MCMLXXX'))
