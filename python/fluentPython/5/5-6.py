# encoding=utf8
# 函数内省
# 函数使用 __dict__ 属性存储赋予它的用户属性。相当于一种基本形式的注解


class C:
    pass


obj = C()


def fun():
    pass


print(sorted(set(dir(fun)) - set(dir(obj))))
# >>>['__call__', '__class__', '__closure__', '__code__', '__defaults__', '__delattr__', '__dict__', '__format__', '__get__', '__getattribute__', '__globals__', '__hash__', '__init__', '__name__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', 'func_closure', 'func_code', 'func_defaults', 'func_dict', 'func_doc', 'func_globals', 'func_name']
