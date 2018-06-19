#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os
import dbm
import pickle
import threading

DB_PATH = os.getcwd()


class BottleBucket(object):
    """
    bottleBucket这个类是将dbm数据库作为最终的存储器，cached_memory作为一个临时存储器每次set和update数据的时候都是将数据
    写进了cached_memory这个字典中，所以每次写进数据中需要通过save函数将cached_memory中的数据写进dbm中，所以很难受的一点，
    数据不是自动写入的而是先缓存，再写入。
    """

    def __init__(self, db_name):
        self.__dict__['db_name'] = db_name
        self.__dict__['db'] = dbm.open(
            os.path.join(DB_PATH, '%s' % db_name), 'c')
        self.__dict__['cached_memory'] = {}

    # 实现a['key'], a['key'] = value, del a['key']功能
    def __getitem__(self, key):
        if key not in self.cached_memory:
            self.cached_memory[key] = pickle.loads(self.db[key])
        return self.cached_memory[key]

    def __setitem__(self, key, value):
        self.cached_memory[key] = value

    def __delitem__(self, key):
        if key in self.cached_memory:
            del self.cached_memory[key]
        del self.db[key]

    # 实现a.key, a.key = value, del a.key功能
    def __getattr__(self, key):
        try:
            return self[key]
        except KeyError:
            raise AttributeError(key)

    def __setattr__(self, key, value):
        self[key] = value

    def __delattr__(self, key):
        try:
            del self[key]
        except KeyError:
            raise AttributeError(key)

    def iter(self):
        return iter(self.ukeys())

    def __contains__(self, key):
        return key in self.ukeys()

    def __len__(self):
        return len(self.keys())

    def keys(self):
        return list(self.ukeys())

    def ukeys(self):
        return set(self.db.keys()) | set(self.cached_memory.keys())

    def update(self, other):
        self.cached_memory.update(other)

    def get(self, key, default=None):
        try:
            return self[key]
        except KeyError:
            if default:
                return default
            raise

    def clear(self):
        for key in self.db.keys():
            del self.db[key]
        self.cached_memory.clear()

    def save(self):
        self.close()
        self.__init__(self.db_name)

    def close(self):
        for key in self.cached_memory.keys():
            pvalue = pickle.dumps(self.cached_memory[key],
                                  pickle.HIGHEST_PROTOCOL)
            if key not in self.db or pvalue != self.db[key]:
                self.db[key] = pvalue
        self.cached_memory.clear()
        self.db.close()

# 数据库的管理类定义, 注意继承的基类, 用thread-local的方式来管理多个数据库


class BottleDB(threading.local):
    def __init__(self):
        self.__dict__['opened_db'] = {}

    def __getitem__(self, key):
        """
        返回key数据库，如果没有将返回一个空数据库
        """
        if key not in self.opened_db:
            self.opened_db[key] = BottleBucket(key)
        return self.opened_db[key]

    def __setitem__(self, key, value):
        if isinstance(value, BottleBucket):
            self.opened_db[key] = value
        elif hasattr(value, 'items'):
            if key not in self.opened_db:
                self.opened_db[key] = BottleBucket(key)
            self.opened_db[key].clear()
            for k, v in value.items():
                self.opened_db[key][k] = v
        else:
            raise ValueError("only dicts and BottleBucket are allowed.")

    def __delitem__(self, key):
        if key in self.opened_db:
            self.opened_db[key].clear()
            self.opened_db[key].save()
            del self.opened_db[key]

    def __getattr__(self, key):
        try:
            return self[key]
        except KeyError:
            raise AttributeError(key)

    def __setattr__(self, key, value):
        self[key] = value

    def __delattr__(self, key):
        try:
            del self[key]
        except KeyError:
            raise AttributeError(key)

    def keys(self):
        return list(self.opened_db.keys())

    def __iter__(self):
        for db in self.opened_db.values():
            yield db

    def __len__(self):
        return len(self.keys())

    def save(self):
        self.close()
        self.__init__()

    def close(self):
        for db in self:
            db.close()
        self.opened_db.clear()
