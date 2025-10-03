def josephus(items, k):
    n = len(items)
    i = 0

    x = n
    ans = []
    for _ in range(n):
        i = (i + k - 1) % x
        ans.append(items.pop(i))
        x -= 1
    return ans


ans = [1, 2, 3, 4, 5, 6, 7]
print(josephus(ans, 3))
