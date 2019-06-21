# 描述
# 中文
# English
# 扔 n 个骰子，向上面的数字之和为 S。给定 n，请列出所有可能的 S 值及其相应的概率。
#
# 你不需要关心结果的准确性，我们会帮你输出结果。
#
# 您在真实的面试中是否遇到过这个题？
# 样例
# 样例 1：
#
# 输入：n = 1
# 输出：[[1, 0.17], [2, 0.17], [3, 0.17], [4, 0.17], [5, 0.17], [6, 0.17]]
# 解释：掷一次骰子，向上的数字和可能为1,2,3,4,5,6，出现的概率均为 0.17。
# 样例 2：
#
# 输入：n = 2
# 输出：[[2,0.03],[3,0.06],[4,0.08],[5,0.11],[6,0.14],[7,0.17],[8,0.14],[9,0.11],[10,0.08],[11,0.06],[12,0.03]]
# 解释：掷两次骰子，向上的数字和可能在[2,12]，出现的概率是不同的。


class Solution:
    # @param {int} n an integer
    # @return {tuple[]} a list of tuple(sum, probability)
    def dicesSum(self, n):
        dp = [[0 for _ in range(n * 6 + 1)] for _ in range(n + 1)]
        for i in range(1, 7):
            dp[1][i] = 1 / 6

        for i in range(1, n * 6 + 1):
            for j in range(1, n + 1):
                for x in range(1, 7):
                    if i - x >= 0:
                        dp[j][i] += dp[j - 1][i - x] * (1 / 6)

        ans = [[i, dp[n][i]] for i in range(n, n * 6 + 1)]
        return ans


n = 3
s = Solution()
print(s.dicesSum(n))
