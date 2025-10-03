n, k = [int(i) for i in input().split()]

dp = [0 for _ in range(n+1)]
dp[0] = 1
dp[1] = 1

for i in range(2, n+1):
    if i > k:
        dp[i] = (2*dp[i-1] - dp[i-k-1]) % 100003
    else:
        dp[i] = 2*dp[i-1] % 100003
print(dp[n])
