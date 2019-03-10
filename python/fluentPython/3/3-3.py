d = {}
key_a = 'a'
key_b = 'b'

print(d)

# 访问两次
if key_a not in d:
    d[key_a] = []
d[key_a].append("hello")
print(d)

# 访问一次
d.setdefault(key_b, []).append("hello")

print(d)
