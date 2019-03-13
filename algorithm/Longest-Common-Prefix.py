class Solution(object):
    def longestCommonPrefix(self, strs):
        """
        :type strs: List[str]
        :rtype: str
        """
        if not strs:
            return ''
        for i in range(len(strs[0])):
            for string in strs[1:]:
                if i >= len(string) or string[i] != strs[0][i]:
                    return strs[0][:i]
        return strs[0]

    def longestCommonPrefix1(self, strs):
        if not strs:
            return ''
        i = -1
        for i, s in enumerate(zip(*strs)):
            # if all(map(lambda x: x == s[0], s)):
            if len(set(s)) == 1:
                continue
            else:
                return strs[0][:i]
        return strs[0][:i + 1]

    def longestCommonPrefix2(self, strs):
        ans = ''
        count = 0
        for i, s in enumerate(zip(*strs)):
            if len(set(s)) == 1 and i == count:
                ans += s[0]
                count += 1
            else:
                break
        return ans


if __name__ == '__main__':
    solution = Solution()
    strs = ['leet', 'leetscode', 'leetcode', 'leetscode']
    strs1 = ['']
    print(solution.longestCommonPrefix2(strs))
