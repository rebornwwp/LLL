#!/usr/bin/env python
# -*- coding:utf-8 -*-
#
#   Author  :   vito
#   E-mail  :   rebornwwp.gmail.com
#   Date    :   17/04/25 23:27:11
#   Desc    :   创建转换表
#

table = "".maketrans("\N{bengali digit one}"
                     "\N{bengali digit two}\N{bengali digit three}", "012")

print("\N{bengali digit one}\N{bengali digit one}".translate(table))
print(table)
print("ax\N{SUPERSCRIPT TWO} + bx + c = 0")
print("\N{RIGHTWARDS ARROW}x")

