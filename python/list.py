#!/usr/bin/env python
# -*- coding:utf-8 -*-
#
#   Author  :   vito
#   E-mail  :   rebornwwp.gmail.com
#   Date    :   17/04/27 00:27:22
#   Desc    :
#

# 可以对于路径的解析，将文件名和目录名分开
first, *mid, last = "hello world is the computer like to say".split()
print("first: ", first)
print("mid: ", mid)
print("last: ", last)


# del 语句作用知识取消对象应用到数据项的绑定，并删除对象引用(这点很重要)


# 当需要对list中部分进行修改的时候,[1,2,3,4,5,6,7,8,9,10],将其中的奇数索引项全部变成0, 下面是例子

a = list(range(1, 11))
print(a)
a[1::2] = [0] * len(a[1::2])
print(a)

# 当使用的情况是用在序列的前插或者后插时候，用list比较好
# 当使用情况需要我们队搜索的时候，用set和dict比较好，这两个的搜索方法是特别优化的，bisect模块提供服务


# 一句求闰年的方法

leaps = [year for year in range(1900, 2000)
         if (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)]
print(leaps)

# 集合类型中，set()中，其添加的对象必须是可哈希运算的对象及对象有个__hash__()的特殊方法，
# 固定类型的数据对象可以放在set中，他们是不变的，但是可变的数据类型(dict, list, set)是不可以放在set中的他们没有hash的方法，因为他们是可变的，这样其哈希值是随着项数的改变而改变的。
"""
s = set()
a = 10
if hasattr(a, '__hash__'):
    s.add(a)
"""


"""
这个函数中*表示在*之后不应该出现位置参数，但是关键字参数是允许的。
def hero(a,b,c,*,units="meter"):

def hero(*, paper="hello", copies="hello"): 这个函数调用的时候，只能使用关键字参数

"""


