#!/usr/bin/env python
# -*- coding:utf-8 -*-

import string
import random

KEY_LEN = 6
KEY_NUM = 200

def base_string():
    return string.digits + string.ascii_letters

def key_gen():
    keylist = [random.choice(base_string()) for _ in range(KEY_LEN)]
    return "".join(keylist)

def key_num(num, result=None):
    if result is None:
        result = []
    for _ in range(num):
        result.append(key_gen())
    return result

def print_key():
    for i in key_num(KEY_NUM):
        print(i)

if __name__ == "__main__":
    print_key()

