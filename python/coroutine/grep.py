# -*- coding: utf-8 -*-

"""
yield as expression

这个时候yield表示通过send函数，发送到其中的字符串，这样这个时候这个函数就是数据的消费者
"""

def grep(pattern):
    print("looking for %s" % pattern)
    while True:
        line = (yield)
        if pattern in line:
            print(line)

# 没有输出
g = grep("python")

# 通过next启动协程或者通过send(None)来启动协程
g.next()
# g.send(None)

g.send("hello world")
g.send("python world")
