# 小Q去商场购物，经常会遇到找零的问题。

# 小Q现在手上有n种不同面值的硬币，每种面值的硬币都有无限多个。

# 为了方便购物，小Q希望带尽量少的硬币，并且要能组合出1到m之间（包含1和m）的所有面值。

# 输入格式
# 第一行包含两个整数m和n。

# 接下来n行，每行一个整数，第 i+1 行的整数表示第 i 种硬币的面值。

# 输出格式
# 输出一个整数，表示最少需要携带的硬币数量。

# 如果无解，则输出-1。

# 数据范围
# 1≤n≤100,
# 1≤m≤109，
# 1≤硬币面值≤109
# 输入样例：
# 20 4
# 1
# 2
# 5
# 10
# 输出样例：
# 5
line = raw_input()
a = line.split()
m, n = int(a[0]), int(a[1])

l = []
for i in range(n):
    a = raw_input()
    l.append(int(a))

l = [i for i in l if i < m]
l.append(m+1)
l = sorted(l)

n = len(l)
print(l)
if 1 not in l:
    print(-1)
else:
    res, s = 0, 0
    for i in range(n - 1):
        k = (l[i+1] - 1 - s + l[i] - 1) / l[i]
        res += k
        s += k * l[i]
        print(k, res, s, l[i])
    print(res)
