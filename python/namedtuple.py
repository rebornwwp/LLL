#!/usr/bin/env python
# -*- coding:utf-8 -*-
#
#   Author  :   vito
#   E-mail  :   rebornwwp.gmail.com
#   Date    :   17/04/26 23:48:13
#   Desc    :
#

"""
column_name:    'col1''col2''col3''col4'
                (val1, val2, val3, val4)


from collections

通过.函数访问数据: named_tuple.col_name
访问字段: named_tuple._fields 将返回列名字段
_make: 一个函数通过实例或者是类名创建新的命名元组 参数为一个序列
_asdict: 函数返回一个字典
_replace:函数修改值，但是不是inplace，知识返回一个新的实例
_source: 类的源代码，可以用exec来运行
getattr: getattr(point, 'x') 返回相应的字段值
__doc__: 可以修改来定制文档

下面是从csv文件或者从数据库中导出数据，每行转化成namedtuple的样式代码
EmployeeRecord = namedtuple('EmployeeRecord', 'name, age, title, department, paygrade')

import csv
for emp in map(EmployeeRecord._make, csv.reader(open("employees.csv", "rb"))):
    print(emp.name, emp.title)

import sqlite3
conn = sqlite3.connect('/companydata')
cursor = conn.cursor()
cursor.execute('SELECT name, age, title, department, paygrade FROM employees')
for emp in map(EmployeeRecord._make, cursor.fetchall()):
    print(emp.name, emp.title)

用默认值方法
Account = namedtuple('Account', 'owner balance transaction_count')
default_account = Account('<owner name>', 0.0, 0)
johns_account = default_account._replace(owner='John')
janes_account = default_account._replace(owner='Jane')

"""

from collections import namedtuple

if __name__ == "__main__":
    Point = namedtuple("Point", ['x', 'y'])
    point = Point(10, y=11)
    print(point[0] + point[1])
    x, y = point
    print(x, y)
    print(point)
    print(Point._make([1, 2]))
    print(point._asdict())
    print(point._replace(x=0))
