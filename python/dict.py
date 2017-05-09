#!/usr/bin/env python
# -*- coding:utf-8 -*-
#
#   Author  :   vito
#   E-mail  :   rebornwwp.gmail.com
#   Date    :   17/04/27 11:56:18
#   Desc    :
#


# 字典对一个键的值做操作，但是不知道键是否存在
# 需要注明的是，键的数据类型必须是可哈希的

d = {'a': 1}
d['a'] = d.get('a', 0) + 1
d['b'] = d.get('b', 0) + 1

print(d)

# 上面是运用原生字典的形式，下面我们将用默认字段，其对每个值对都有一个工厂函数，当对键值访问的时候，键如果不存在，将用工厂函数进行初始化
# 下面这个就是多出来的性质，其他的和原生字典没有什么差别

from collections import defaultdict

words = defaultdict(int)  # int为工厂函数
# 用lambda 创建工厂函数
test_lambda = defaultdict(lambda: -1)
words['a'] += 1
print(words)


# 有序字典 以数据插入的顺序进行存储 改变已有键的值不会打乱字典顺序

import collections
d = dict(a=10, c=11, d=19)
d = collections.OrderedDict(sorted(d.items()))  # 生成排序字典
