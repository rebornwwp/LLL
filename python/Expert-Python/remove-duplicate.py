# encoding=utf-8
l = [1, 2, 2, 3, 3, 3]
# 第一种去重方式
print({}.fromkeys(l).keys())

# 第二种去重方式
print(list(set(l)))

# PS: 在字典较大的情况下, 列表去重(1)略慢了
