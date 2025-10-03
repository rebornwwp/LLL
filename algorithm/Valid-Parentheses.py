class Solution(object):
    def isValid(self, s):
        """
        :type s: str
        :rtype: bool
        """
        left = '([{'
        right = ')]}'
        left_pa = list()
        for i in s:
            if i not in left + right:
                return False
            if i in left:
                left_pa.append(i)
            if i in right:
                if len(left_pa) > 0:
                    if right.index(i) != left.index(left_pa.pop()):
                        return False
                elif len(left_pa) == 0:
                    return False
        if len(left_pa) > 0:
            return False
        return True

    def isValid1(self, s):
        a = "([{"
        b = ")]}"
        c = []
        for i in s:
            if i in a:
                c.append(i)
            elif i in b:
                if len(c) == 0 and i:
                    return False
                if a.index(c.pop()) != b.index(i):
                    return False
        return len(c) == 0


if __name__ == '__main__':
    s = '()'
    solution = Solution()
    print(solution.isValid(s))
    print(solution.isValid1(s))
