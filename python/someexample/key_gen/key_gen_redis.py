#!/usr/bin/env python
# -*- coding:utf-8 -*-

import string
import random
import redis


KEY_LEN = 6
KEY_NUM = 200
LIST_NAME = 'key'


def base_string():
    return string.digits + string.ascii_letters


def key_gen():
    key_list = [random.choice(base_string()) for _ in range(KEY_LEN)]
    return "".join(key_list)


def key_num(num, result=None):
    if result is None:
        result = []
    for _ in range(KEY_NUM):
        result.append(key_gen())
    return result


def redis_init():
    r = redis.Redis(host='localhost', port=6379, db=0)
    return r


def push_to_redis(key_list):
    for key in key_list:
        redis_init().lpush(LIST_NAME, key)


def get_from_redis():
    key_list = redis_init().lrange(LIST_NAME, 0, -1)
    for key in key_list:
        print(key)

if __name__ == "__main__":
    push_to_redis(key_num(KEY_NUM))
    get_from_redis()
