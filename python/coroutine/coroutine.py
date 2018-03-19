# -*- coding: utf-8 -*-

"""
using a decorator
每次都要用.next()函数来开启协程，总是忘记
利用一个装饰器来解决这样的问题
这个今后肯定会用到
"""

from functools import wraps
import six # on PY2K: 'g.next()' and onPY3K: 'next(g)' 可以通过这个方式兼容


def coroutine(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        cr = func(*args, **kwargs)
        six.next(cr)
        # cr.__next__()
        # cr.send(None)
        # 一定要用send(None), next函数将产生错误, 但是可以用__next__()函数
        # https://stackoverflow.com/questions/1073396/is-generator-next-visible-in-python-3-0
        return cr
    return wrapper


@coroutine
def grep(pattern):
    print("looking for %s" % pattern)
    while True:
        line = (yield)
        if pattern in line:
            print(line)


if __name__ == "__main__":
    a = grep('python')
    a.send("hello")
    a.send("python hello")
    a.send("python l")
    # closing a coroutine
    a.close()
