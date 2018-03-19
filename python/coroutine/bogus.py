# -*- coding: utf-8 -*-

"""
生成器是生成数据到iteration
协程是数据的消费者
不要混淆这两个概念
协程不要和iteration混成一团

提一下iteration是什么，就像是是for i in list1:这样遍历一个东西过程

There is a use of having yield produce a value in a coroutine, but it's not tied to iteration.
"""

def countdown(n):
    print("Counting down from ", n)
    while n > 0:
        newvalue = (yield n)
        # 有新的值被send到函数中，就重置n为新的值
        if newvalue is not None:
            n = newvalue
        else:
            n -= 1


if __name__ == "__main__":
    c = countdown(5)
    for i in c:
        print(i)
        if i == 5:
            c.send(3)
