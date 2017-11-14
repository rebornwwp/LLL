# encoding=utf-8

d = {'a': 1, 'b': 2}

# 粗暴的写法
for k, v in d.items():
    exec('{}={}'.format(k, v))
print(a)
print(b)

# 优雅的写法
globals().update(d)
print(globals())
print(a)
print(b)
