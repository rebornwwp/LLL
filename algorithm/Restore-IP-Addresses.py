# Given a string containing only digits, restore it by returning all possible valid IP address combinations.

# Example:

# Input: "25525511135"
# Output: ["255.255.11.135", "255.255.111.35"]


class Solution(object):
    def restoreIpAddresses(self, s):
        """
        :type s: str
        :rtype: List[str]
        """
        if len(s) == 0:
            return []

        def dfs(s, temp, ans):
            if len(temp) == 4 and len(s) == 0:
                ans.append(temp[:])
                return

            if len(temp) == 4 and len(s) > 0:
                return
            if len(temp) < 4 and len(s) == 0:
                return

            # for i in range(1, 4):
            # 这里需要注意的是考虑最后一次搜索时，s的长度小于3的时候，当s长度为2的时候比如s='35'
            # s[:2] 和s[:3]是取的相同的长度 都为35，这样搜索过程中多搜索了一次
            r = min(4, len(s) + 1)
            for i in range(1, r):
                if int(s[:i]) < 256 and (i == 1 or (i > 1 and s[0] != '0')):
                    temp.append(s[:i])
                    dfs(s[i:], temp, ans)
                    temp.pop()
        ans = []
        dfs(s, [], ans)
        return ['.'.join(l) for l in ans]


s = Solution()
print(s.restoreIpAddresses('25525511135'))
