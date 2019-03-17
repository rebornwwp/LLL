# encoding=utf8

# Given a string containing digits from 2-9 inclusive, return all possible letter combinations that the number could represent.
# A mapping of digit to letters (just like on the telephone buttons) is given below. Note that 1 does not map to any letters.
#
#
#
# Example:
#
# Input: "23"
# Output: ["ad", "ae", "af", "bd", "be", "bf", "cd", "ce", "cf"].
# Note:
#
# Although the above answer is in lexicographical order, your answer could be in any order you want.


class Solution:
    def letterCombinations(self, digits):
        """
        :type digits: str
        :rtype: List[str]
        """
        # O(n*3^n)
        d = {
            "2": 'abc',
            "3": 'def',
            "4": 'ghi',
            "5": 'jkl',
            "6": 'mno',
            "7": 'pqrs',
            "8": 'tuv',
            "9": 'wxyz',
        }
        a = []
        for i in digits:
            if not a:
                for j in d[i]:
                    a.append(j)
            else:
                a = [j + k for j in a for k in d[i]]
        return a

    def letterCombinations1(self, digits):
        """
        DFS
        """
        # 最坏的时候O(4^n)(全是7)
        maps = {
            "2": 'abc',
            "3": 'def',
            "4": 'ghi',
            "5": 'jkl',
            "6": 'mno',
            "7": 'pqrs',
            "8": 'tuv',
            "9": 'wxyz',
        }
        result = []
        if len(digits) == 0:
            return result
        self.dfs(digits, maps, '', 0, result)
        return result

    def dfs(self, digits, maps, current_str, index, result):
        """
        :type digits: string 输入的数字
        :type maps: dict 数字与字母对照表
        :type current_str: string 深度搜索的时候，进行到某一个状态的时候，此时的保存的字符串
        :type index: int 此时我们对index角标的数字惊醒搜索
        :type result: [string] 收集结果的一个容器
        """
        if index == len(digits):
            result.append(current_str)
        else:
            for c in maps[digits[index]]:
                temp = current_str + c
                self.dfs(digits, maps, temp, index + 1, result)

    def letterCombinations2(self, digits):
        """
        using product function in python. it is great than we write
        """
        if not digits:
            return []
        from itertools import product
        maps = {
            "2": 'abc',
            "3": 'def',
            "4": 'ghi',
            "5": 'jkl',
            "6": 'mno',
            "7": 'pqrs',
            "8": 'tuv',
            "9": 'wxyz',
        }
        temp = []
        for i in digits:
            temp.append(maps[i])
        return [''.join(item) for item in product(*temp)]

    def letterCombinations3(self, digits):
        """
        functional programming
        变相的dfs
        """
        maps = {
            "2": 'abc',
            "3": 'def',
            "4": 'ghi',
            "5": 'jkl',
            "6": 'mno',
            "7": 'pqrs',
            "8": 'tuv',
            "9": 'wxyz',
        }
        return reduce(lambda acc, d: [x + y for x in acc for y in maps[d]], digits, [''])

    def letterCombinations4(self, digits):
        """
        dfs
        """
        ans = []
        def dfs(digits, index, curr, ans):
            if index == len(digits):
                return
            ans.append(curr)


if __name__ == "__main__":
    s = Solution()
    print(s.letterCombinations("23"))
    print(s.letterCombinations1("23"))
    print(s.letterCombinations2("23"))
    print(s.letterCombinations3("23"))
