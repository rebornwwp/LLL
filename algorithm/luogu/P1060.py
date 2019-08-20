total, n = [int(i) for i in input().split()]

vws = [[int(i) for i in input().split()] for _ in range(n)]

dp = [0 for _ in range(total + 1)]

for vw in vws:
    for j in range(len(dp)-1, -1, -1):
        if j >= vw[0]:
            dp[j] = max(dp[j], dp[j - vw[0]] + vw[0] * vw[1])

print(dp[total])
