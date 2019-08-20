n, m = [int(i) for i in input().split()]

prices = [int(i) for i in input().split()]


dp = [0 for _ in range(m + 1)]
dp[0] = 1

for price in prices:
    print(list(range(m, price - 1, -1)))
    for i in range(m, price - 1, -1):
        dp[i] += dp[i - price]

print(dp[m])
