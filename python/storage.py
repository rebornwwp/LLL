#!/usr/bin/env python
# encoding: utf-8


class Storage(dict):
    """
    对字典数据结构的扩展可以将"obj.foo"与"obj['foo']"等效的用法
    """
    def __getattr__(self, key):
        try:
            return self[key]
        except KeyError as k:
            raise AttributeError(k)

    def __setattr__(self, key, value):
        self[key] = value

    def __delattr__(self, key):
        try:
            del self[key]
        except keyError as k:
            raise AttribuError(k)

    def __repr__(self):
        return '<Storage ' + dict.__repr__(self) + '>'


storage = Storage


def storify(mapping, *requireds, **defaults):
    _unicode = defaults.pop('_unicode', False)
    to_unicode = safeunicode
    if _uncode is not False and hasattr(_unicode, "__call__"):
        to_unicode = _unicode

    def unicodify(s):
        if _unicode and isinstance(s, str): return to_unicode(s)
        else: return s


if __name__ == "__main__":
    o = storage(a=1)
    print(o.a)
    del o.a
    #print(o.a)
    print(storage)
