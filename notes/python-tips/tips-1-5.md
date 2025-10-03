# tips 1 *args **kwargs

## 基本用法
``` python
# 例子
def print_everything(*args):
    for count, thing in enumerate(args):
        print('{0}, {1}'.format(count, thing))
>>> print_everything('apple', 'banana', 'cabbage')
0. apple
1. banana
2. cabbage


def table_everything(**kwargs):
    for name, value ink wargs.items():
        print('{0} = {1}'.format(name, value))

>>> table_thing(apple = 'fruit', cabbage = 'vegetable')
cabbage = vegetable
apple = fruit
```
* *args 基于位置的参数可以无限化，传入之后args是tuple类型的
* **kwargs基于key-value的参数无限化，传入之后kwargs是dict类型

``` python
#用法一 将一个tuple或者一个list传入到*args中
l = [1,2,3,4,5]
print_everything(*l)
l = tuple([1,2,3,4,5])
print_everything(*l)

# 用法二 将一个dict传入到**kwargs中
d = {"a": 123, "b": 456}
table_thing(**d)
```

## 其他用法

### 用于subclassing

``` python
class Foo(object):
    def __init__(self, value1, value2):
        print(value1, value2)


class MyFoo(Foo):
    def __init__(self, *args, **kwargs):
        print("myfoo")
        super(MyFoo, self).__init__(*args, **kwargs)
```
通过这种方法可以扩展Foo，不用太了解Foo类具体实现，这样对于api改变的时候为特别方便，总是将传入MyFoo的参数传到Foo中


# tips 2 debugging
pdb

## 开启调试模式的两种方法
### 从命令行调试

``` bash
$ python -m pdb my_script.py
```

### 从代码中设置调试

``` python
import pdb

def make_bread():
    pdb.set_trace()
    return "I do not have time"

print(make_bread())
```
不常用所以给出一个学习的网址即可
[This link](https://github.com/spiside/pdb-tutorial)

# tips 3 Generators

三个不容易的分辨的概念
* iterable
* iterator
* iteration

## iterable

An iterable is any object in Python which has an __iter__ or a __getitem__ method defined which returns an iterator or can take indexes (Both of these dunder methods are fully explained in a previous chapter). In short an iterable is any object which can provide us with an iterator. So what is an iterator?

## iterator

An iterator is any object in Python which has a next (Python2) or __next__ method defined. That’s it. That’s an iterator. Now let’s understand iteration.

## iteration

In simple words it is the process of taking an item from something e.g a list. When we use a loop to loop over something it is called iteration. It is the name given to the process itself. Now as we have a basic understanding of these terms let’s understand generators.

## generators

Generators are iterators, but you can only iterate over them once.It’s because they do not store all the values in memory, they generate the values on the fly.  大多数情况下都是通过函数产生的，不是通过return，而是通过yield。生成器在数据量大的数据结构中，其不会同时对数据分配空间，这样就比返回list的函数要占用更少的资源。

``` python
def generator_function():
    for i in range(10):
        yield i

for item in generator_function():
    print(item)
# Output:
# 0
# 1
# 2
# 3
# 4
# 5
# 6
# 7
# 8
# 9


def generator_function():
    for i in range(3):
        yield i

gen = generator_function()
print(next(gen))
# Output: 0
print(next(gen))
# Output: 1
print(next(gen))
# Output: 2
print(next(gen))
# Output: Traceback (most recent call last):
#            File "<stdin>", line 1, in <module>
#         StopIteration
```
上面的例子都是通过函数中用yield的方法创建生成器的，下面将通过一个内建函数**iter**，其可以从一个iterable的变量中生成iterator。
``` python
my_string = "Yahoo"
my_iter = iter(my_string)
print(next(my_iter))
```

# tips 4 map, filter and reduce

## map
``` python
items = [1,2,3,4,5]
squared = list(map(lambda x: x * x, items))
```

## filter

```python
number_lsit = range(-5, 5)
less_than_zero = list(filter(lambda x: x < 0, number_list))
```

## reduce

```python
from functools import reduce
items = [1,2,3,4,5]
product = reduce(lambda x, y: x * y, items)
```

# tips 5 set Data Structure

not contain duplicate values

```python
# bad example
some_list = ['a', 'b', 'c', 'b', 'd', 'm', 'n', 'n']

duplicates = []
for value in some_list:
    if some_list.count(value) > 1:
        if value not in duplicates:
            duplicates.append(value)

print(duplicates)
# Output: ['b', 'n']

# good example
some_list = ['a', 'b', 'c', 'b', 'd', 'm', 'n', 'n']
duplicates = set([x for x in some_list if some_list.count(x) > 1])
print(duplicates)
```

## other operation

### intersection

```python
valid = set(['yellow', 'red', 'blue', 'green', 'black'])
input_set = set(['red', 'brown'])
print(input_set.intersection(valid))
# Output: set(['red'])
```

### difference

``` python
valid = set(['yellow', 'red', 'blue', 'green', 'black'])
input_set = set(['red', 'brown'])
print(input_set.difference(valid))
# Output: set(['brown'])
```

if you want to know other operation, the official document is recommended.  
^-\^