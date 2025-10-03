class Solution:
    def numPairsDivisibleBy60(self, time: List[int]) -> int:

        d = {}

        for t in time:
            t = t % 60
            d[t] = d.get(t, 0) + 1

        ans = 0

        if 0 in d:
            ans += d[0] * (d[0] - 1) // 2

        if 30 in d:
            ans += d[30] * (d[30] - 1) // 2

        for i in range(1, 30):
            ans += d.get(i, 0) * d.get(60 - i, 0)

        return ans
