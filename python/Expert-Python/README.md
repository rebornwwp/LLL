# note

```
http://dongweiming.github.io/Expert-Python/#1
```

```
from __future__ import absolute_import
不是支持了绝对引入,而是拒绝隐式引入
$cat for_absolute_import/string.py
a = 1
$cat for_absolute_import/main.py
import string # 其实我们要的是当前目录下的string模块
>>> from for_absolute_import.main import string
>>> string # 是隐式引入的
<module 'for_absolute_import.string' from 'for_absolute_import/string.py'>
>>> 1
1


# 我来修改下
$cat for_absolute_import/main.py
from __future__ import absolute_import
import string
>>> from for_absolute_import.main import string
>>> string # 看这里其实还是在用string模块
<module 'string' from '/System/Library/Frameworks/Python.


# 标准做法
from __future__ import absolute_import
from .string import a # 比较常用的风格
from for_absolute_import.string import a \
# 官方推荐的风格,强烈建议这样的风格
```
