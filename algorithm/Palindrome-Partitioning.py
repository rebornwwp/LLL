# Given a string s, partition s such that every substring of the partition is a palindrome.

# Return all possible palindrome partitioning of s.

# Example:

# Input: "aab"
# Output:
# [
#   ["aa","b"],
#   ["a","a","b"]
# ]


class Solution(object):
    def partition(self, s):
        """
        :type s: str
        :rtype: List[List[str]]
        """
        if len(s) == 0:
            return []

        def dfs(s, temp, ans, store):
            if len(s) == 0:
                ans.append(temp[:])
                return

            for i in range(len(s)):
                if s[:i + 1] in store:
                    temp.append(s[:i + 1])
                    dfs(s[i + 1:], temp, ans, store)
                    temp.pop()
                elif s[:i + 1] == s[:i + 1][::-1]:
                    store.add(s[:i + 1])
                    temp.append(s[:i + 1])
                    dfs(s[i + 1:], temp, ans, store)
                    temp.pop()
        ans = []
        dfs(s, [], ans, set())
        return ans


s = Solution()
print(s.partition('aab'))
