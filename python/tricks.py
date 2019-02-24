# 获取一个列表中频次最多的值

a = [1, 2, 3, 1, 1, 1]
print(max(set(a), key=a.count))

from collections import Counter

cnt = Counter(a)
print(cnt.most_common(3))

# 检测两个词语是否是同字母异构词
print(Counter("hello") == Counter("heoll"))

# 转置一个二维数组
a = [[1, 2, 3], [4, 5, 6]]
transposed = zip(*a)
print(list(transposed))

# 链式函数
def add(a, b):
    return a + b

def product(a, b):
    return a * b

b = True
print((add if b else product)(10, 5))

# 合并两个字典
d1 = {'a': 1}
d2 = {'b': 2}
print({**d1, **d2})
print(dict(d1.items() | d2.items()))
d1.update(d2)
print(d1)

# Min and Max index in List
a = [40, 10, 20, 30]

def minIndex(lst):
    return min(range(len(lst)), key=lst.__getitem__)

def maxIndex(lst):
    return max(range(len(lst)), key=lst.__getitem__)

print(minIndex(a))
print(maxIndex(a))