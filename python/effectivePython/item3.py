# -*- coding: utf-8 -*-

"""
编码问题
python2中str和unicode
python3中bytes和str
其中前者都是八位值，后者都是unicode，python2中和pythn3中初始化一个字符串都是一个str类型的，
python中程序核心的编码使用utf-8，所以在python2中需要将字符串都统一成unicode的形式，str解码（decode）到unicode，
python3中也是同样的道理，bytes也是需要解码到unicode的

"""

def to_str(bytes_or_str):
    if isinstance(bytes_or_str, bytes):
        value = bytes_or_str.decode("utf-8")
    else:
        value = bytes_or_str
    return value


def to_bytes(bytes_or_str):
    if isinstance(bytes_or_str, str):
        value = bytes_or_str.encode("utf-8")
    else:
        value = bytes_or_str
    return value


if __name__ == '__main__':
    a = "hello world"
    b = to_str(a)
    print(b)
    c = to_bytes(b)
    print(b)
