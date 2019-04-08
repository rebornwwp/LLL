N = int(raw_input())

l = [int(i) for i in raw_input().split()]


dp = [0 for _ in range(N+1)]

pay = 0
for i in range(1, len(l) + 1):
    dp[i] = l[i-1]
    for j in range(i-1, 0, -1):
        if dp[j] * dp[i] < 0:
            pay += min(abs(dp[j]), abs(dp[i])) * (i - j)
            temp = dp[j] + dp[i]
            dp[j] = max(0, temp)
            dp[i] = min(0, temp)


def minCost(l):
    res = 0
    dp = 0
    for i in l:
        res += abs(dp)
        dp += i
    return res

print(minCost(l))
