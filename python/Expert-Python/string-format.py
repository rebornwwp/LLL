# encoding=utf-8
from datetime import datetime
import sys

print("{key}={value}".format(key="a", value=10))
print("[{0:<10}], [{0:^10}], [{0:*>10}]".format("a"))
print("{0.platform}".format(sys))
print("{0[a]}".format(dict(a=10, b=20)))
print("{0[5]}".format(range(10)))
print("My name is {0} :-{{}}".format('Fred')) # 真得想显示{},
print("{0!r:20}".format("Hello"))
print("{0!s:20}".format("Hello"))
print("Today is: {0:%a %b %d %H:%M:%S %Y}".format(datetime.now()))
