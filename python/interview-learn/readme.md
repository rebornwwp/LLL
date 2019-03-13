# 文件操作

## 1.有一个jsonline格式的文件file.txt大小约为10K

``` python
def get_lines():
    with open('file.txt','rb') as f:
        return f.readlines()

if __name__ == '__main__':
    for e in get_lines():
        process(e) # 处理每一行数据
```

现在要处理一个大小为10G的文件，但是内存只有4G，如果在只修改get_lines 函数而其他代码保持不变的情况下，应该如何实现？需要考虑的问题都有那些？

``` python
def get_lines():
    with open('file.txt','rb') as f:
        for i in f:
            yield i
```

### mmap

mmap是一种虚拟内存映射文件的方法，即可以将一个文件或者其它对象映射到进程的地址空间，实现文件磁盘地址和进程虚拟地址空间中一段虚拟地址的一一对映关系。

普通文件被映射到虚拟地址空间后，程序可以像操作内存一样操作文件，可以提高访问效率，适合处理超大文件

``` python
import mmap
# write a simple example file
with open("hello.txt", "wb") as f:
    f.write("Hello Python!\n")
with open("hello.txt", "r+b") as f:
    # memory-map the file, size 0 means whole file
    mm = mmap.mmap(f.fileno(), 0)
    # read content via standard file methods
    print mm.readline()  # prints "Hello Python!"
    # read content via slice notation
    print mm[:5]  # prints "Hello"
    # update content using slice notation;
    # note that new content must have same size
    mm[6:] = " world!\n"
    # ... and read again using standard file methods
    mm.seek(0)
    print mm.readline()  # prints "Hello  world!"
    # close the map
    mm.close()
```

Pandaaaa906提供的方法

``` python

from mmap import mmap

def get_lines(fp):
    with open(fp,"r+") as f:
        m = mmap(f.fileno(), 0)
        tmp = 0
        for i, char in enumerate(m):
            if char == b"\n":
                yield m[tmp:i+1].decode()
                tmp = i+1

if __name__=="__main__":
    for i in get_lines("fp_some_huge_file"):
        print(i)
```

要考虑的问题有：内存只有4G无法一次性读入10G文件，需要分批读入分批读入数据要记录每次读入数据的位置。分批每次读取数据的大小，太小会在读取操作花费过多时间。 <https://stackoverflow.com/questions/30294146/python-fastest-way-to-process-large-file>

## python中变量的作用域

函数作用域的LEGB顺序

1.什么是LEGB?

L： local 函数内部作用域

E: enclosing 函数内部与内嵌函数之间

G: global 全局作用域

B： build-in 内置作用

python在函数里面的查找分为4种，称之为LEGB，也正是按照这样顺序来查找的

``` python
def func1(param=None):
    def func2():
        if not param:
            param = 'default'
        print param
    # Just return func2.
    return func2


if __name__ == '__main__':
   func1('test')()


# fix it
def func1(param=None):
    def func2(param2=param):
        if not param2:
            param2 = 'default'
        print param2
    # Just return func2.
    return func2
```