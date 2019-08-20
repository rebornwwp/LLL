total, m = [int(i) for i in input().split()]

items = [[int(i) for i in input().split()] for _ in range(m)]

main_items = dict()
for i, item in enumerate(items):
    if item[2] == 0:
        main_items[i + 1] = dict(value=item, deps=[])

for item in items:
    if item[2] != 0:
        main_items[item[2]]['deps'].append(item)

dp = [0 for _ in range(total + 1)]

print(main_items)
for key, item in main_items.items():
    for i in range(total, item['value'][0] - 1, -1):

        if i - item['value'][0] >= 0:
            dp[i] = max(dp[i], dp[i - item['value'][0]] +
                        item['value'][0] * item['value'][1])

        if len(item['deps']) == 0:
            continue
        if len(item['deps']) >= 1:
            if i - item['value'][0] - item['deps'][0][0] >= 0:
                dp[i] = max(dp[i],
                            dp[i - item['value'][0] - item['deps'][0][0]] + item['deps'][0][0]*item['deps'][0][1])
        if len(item['deps']) >= 2:
            if i - item['value'][0] - item['deps'][1][0] >= 0:
                dp[i] = max(dp[i],
                            dp[i - item['value'][0] - item['deps'][1][0]] + item['deps'][1][0]*item['deps'][1][1])
            if i - item['value'][0] - item['deps'][0][0] - item['deps'][1][0] >= 0:
                dp[i] = max(dp[i],
                            dp[i - item['value'][0] - item['deps'][0][0] - item['deps'][1][0]] + item['deps'][0][0]*item['deps'][0][1] + item['deps'][1][0]*item['deps'][1][1])

print(dp[total])
