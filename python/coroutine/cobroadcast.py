# -*- coding: utf-8 -*-

"""
multiple target
Coroutines provide more powerful data routing possibilities than simple iterators
If you built a collection of simple data processing components, you can glue them together into complex arrangements of pipes, branches, merging, etc.

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
    f = open("access-log")
    follow(f, broadcast([grep('python', printer()),
                         grep('ruby', printer()),
                         grep('haskell', printer())]))
