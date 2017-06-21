#!/usr/bin/env python
# -*- coding:utf-8 -*-

import string
import random

KEY_LEN = 6
KEY_NUM = 200


def base_string():
    return string.digits + string.ascii_letters


def key_gen():
    key_list = [random.choice(base_string()) for _ in range(KEY_LEN)]
    return "".join(key_list)


def print_list(func):
    def print_key(num):
        for i in func(num):
            print(i)
    return print_key


@print_list
def key_num(num, result=None):
    if result is None:
        result = []
    for _ in range(num):
        result.append(key_gen())
    return result


if __name__ == "__main__":
    key_num(KEY_NUM)
