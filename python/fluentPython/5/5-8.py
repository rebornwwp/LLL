from inspect import signature

# 获取函数的参数信息
# 函数的 __defaults__ 属性， 他的值是一个元组，里面保存着定位参数和关键字参数的默认值。
# 仅限关键字参数的默认值在 __kwdefaults__ 属性中。 参数名称在 __code__中,它的值是一个code对象引用，
# 自身也有很多属性。


def clip(text, max_len=80):
    """在max——le
    """
    end = None
    if len(text) > max_len:
        spece_before = text.rfind(' ', 0, max_len)
        if space_before >= 0:
            end = space_before
        else:
            space_after = text.rfind(' ', max_len)
            if space_after >= 0:
                end = space_after
    if end is None:
        end = len(text)
    return text[:end].rstrip()


# 参数默认值
print(clip.__defaults__)

print(clip.__kwdefaults__)

print(clip.__code__)

# 函数中所有参数参数名，包含了函数体中创建的局部变量
print(clip.__code__.co_varnames)

# 函数传入参数的个数, 说明了co_varnames的前几个是函数传入的参数
print(clip.__code__.co_argcount)

# 利用inspect模块来获取函数的签名


sig = signature(clip)
print(sig)
print(str(sig))
print(sig.parameters)
for name, param in sig.parameters.items():
    print(name, '\t->\t', param)

# __annotations__ 注解的意义，将 def fun(a: int, b: int) -> int 函数证明中的参数信息都加入__annotations__ 中，方便IDE做分析
