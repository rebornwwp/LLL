# -*- coding: utf-8 -*-

"""
multiple target
"""

from coroutine import coroutine
from cofollow import follow, grep, printer


@coroutine
def broadcast(targets):
    while True:
        line = (yield)
        if line is not None:
            for target in targets:
                target.send(line)


if __name__ == "__main__":
    # 在同一个打印器中输出
    p = printer()
    f = open("access-log")
    follow(f, broadcast([grep('python', p),
                         grep('ruby', p),
                         grep('haskell', p)]))
