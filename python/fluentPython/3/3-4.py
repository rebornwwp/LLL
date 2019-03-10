# 映射的弹性健查询

# 1 defaultdict

# 2 自定义 __missing__ 方法
#  自定义映射类型的时候，更合适的策略是用继承collections的UserDict类
# 在 __getitem__ 找不到健的时候，python将会自动调用__missing__方法，而不是抛出异常
# 所以__missing__只能被__getitem__调用


class StrKeyDict0(dict):
    def __missing__(self, key):
        if isinstance(key, str):
            raise KeyError(key)
        return self[str(key)]

    def get(self, key, default=None):
        try:
            return self[key]
        except KeyError:
            return default

    def __contains__(self, key):
        return key in self.keys() or str(key) in self.keys()


d = StrKeyDict0([('2', 'two'), ('4', 'four')])
print(d['2'])
# 1 先使用__getitem__调用，然后使用__missing__调用，之后在用__getitem__调用，找到健返回相应的值，
# 找不到调用__missing__. 此时1变成了字符串，表示确实找不到这个建，所以抛出异常
print(d[1])
