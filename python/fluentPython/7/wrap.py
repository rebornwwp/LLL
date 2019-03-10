import functools
import html
import numbers
import time
from collections import abc
from functools import singledispatch


def clock(func):
    # 协助构建良好行为的装饰器
    @functools.wraps(func)
    def clocked(*args, **kwargs):
        t0 = time.time()
        result = func(*args, **kwargs)
        elasped = time.time() - t0
        name = func.__name__
        print(elasped)
        print(name)
        return result
    return clocked


@clock
def fun():
    print("hello")


# 备忘功能, maxsize存储的数目，
@functools.lru_cache(maxsize=128, typed=False)
@clock
def fib(n):
    if n < 2:
        return n
    return fib(n - 1) + fib(n - 2)


fun()
print(fib(100))


# singledispatch 可以将整体方案拆分成多个模块，直观来说就是将普通函数变成泛函数(generic function)

@singledispatch
def htmlize(obj):
    content = html.escape(repr(obj))
    return '<pre>{}</pre>'.format(content)


@htmlize.register(str)
def _(text):
    content = html.escape(text).replace('\n', '<br>\n')
    return '<p>{0}</p>'.format(content)


@htmlize.register(numbers.Integral)
def _(n):
    return '<pre>{0} (0x{0:x})</pre>'.format(n)


@htmlize.register(tuple)
@htmlize.register(abc.MutableSequence)
def _(seq):
    return "hello"

# singledispatch 的优点可以在系统的任意地方和任意模块中注册专门的函数
