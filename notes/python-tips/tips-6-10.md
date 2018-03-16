# tips 6 ternary operators

``` python
# blueprint 1
condition_is_true if condition else condition_is_false

# example 1
is_fat = True
state = 'fat' if is_fat else 'not fat'


# blueprint 2
(if_test_is_false, if_test_is_true)[test]

# example 2
fat = True
fitness = ('skinny', 'fat')[fat]
print('Ali is', fitness)

```

上面的第二个`blueprint`可能有点令人疑惑，分开说就是前面一个`tuple`或者`list`保存两个数据，`True=1`取列表的第二个数据，`False=0`取列表的第一个数据。 这里只是介绍第二种方法，但这种方法并不推荐。

``` python
condition = True
print(2 if condition else 2/0)

print((1/0, 1)[condition])
```
上面就是我们对于比较例子，当为第一个的时候句子将会按照`if-else`逻辑树进行下去，并不会抛出`ZeroDivisionError`，但是在第二个例子中我们能看出直接会抛出`ZeroDivisionError`，这就是运用`tuple`和`list`的时候，将会先计算出`tuple`或者是`list`，才能进行数据的读取。


# tips 7 decoratoros

## Everything in Python is an object
## Defining functions within functions
``` python
def hi():

    def greet():
        print("greet")
    
    def welcome():
        print("welcome")
    
    greet()
    welcome()
    print("hi")

hi()
```
## Returning functions from within functions

``` python
# example 1
def hi(name='Allen'):

    def greet():
        return 'greet'
    
    def welcome():
        return 'welcom'
    
    if name == 'Allen':
        return greet
    else:
        return welcome

return_function = hi()
return_function()

# example 2
def func1(arg1):

    def func2(*args):
        from functools import reduce
        return arg1 * (reduce(lambda x, y: x * y, args))
    return func2

a = func1(10)
print(a(1,2,3,4,5))
```

## Giving a function as an argument to another function

``` python
def hi():
    print("hi")

def doSomethingBeforeFunc(func):
    print("before function do")
    func()

doSomethingBeforeFunc(hi)
```

## Writing your first decorator

``` python
def a_new_decorator(func):

    def wrapTheFunction():
        print("do somthing before the function")

        func()

        print("do something after the function")
    
    return wrapTheFunction

def a_function_need_decorate():
    print("I am the function need to decorated")

a_function_need_decorate()

print("="*50)
decorated_function = a_new_decorator(a_function_need_decorate)
decorated_function()
```
上面是传统装饰器，下面将利用python中的语法糖`@`来进行装饰

``` python
@a_new_decorator
def a_function_need_decorate():
    """ decorate me """
    print("I am the function")

a_function_need_decorate()

# 输出的结果将会是'wrapTheFunction', 但是我们希望的结果是 'a_function_need_decorate'
print(a_function_need_decorate.__name__)
```
上面的装饰器有一个副作用，将会修改原来的函数的一些参数的性质，这样对于有些情况并不是特别友好（耦合性太差？），下面我们将解决提到的这个的问题。

``` python
from functools import wraps

def decorator_name(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if not can_run: # 利用一个全局变量做判断
            return "the function can't run"
        return f(*args, **kwargs)
    return decorated

@decorator_name
def hi():
    print("function is running!")

can_run = True
hi()

can_run = False
hi()

print(hi.__name__)
```

## use case

### Authorization
``` python
from functools import wraps

def requires_auth(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        auth = request.authorization
        if not auth or not check_auth(auth.username, auth.password):
            authenticate()
        return f(*args, **kwargs)
    return decorated
```

### Logging

``` python
from functools import wraps

def logit(func):
    @wraps(func)
    def with_logging(*args, **kwargs):
        print(func.__name__ + " was called")
        return func(*args, **kwargs)
    return with_logging

@logit
def addition_func(x):
   """Do some math."""
   return x + x


result = addition_func(4)
```

## Decorators with Arguments

### Nesting a Decorator Within a Function

上面的装饰器都是无参数的装饰器，下面将介绍有参数的装饰器

``` python
from functools import wraps

def logit(logfile='out.log'):
    def logit_decorator(func):
        @wraps(func)
        def wrapped_function(*args, **kwargs):
            called_string = func.__name__ + ' was called.' + '\n'
            print(called_string)
            with open('out.log', 'a') as log_file:
                log_file.write(called_string)
            func(*args, **kwargs)
        return wrapped_function
    return logit_decorator

@logit()
def hi():
    print('hi')

hi()
```

### Decorator Classes

``` python
class decorator(object):
    def __init__(self, func):
        self.func = func

    def __call__(self, *args, **kwargs):
        print('called {func} with args: {args} and kwargs : {kwargs}'.format(func=self.func.__name__, args=args, kwargs=kwargs))
        return self.func(*args, **kwargs)
    

@decorator
def func(x, y):
    return x, y

print(func(1, 2))
```


# tips 8 global & return

``` python
# return
def add(value1, value2):
    return value1 + value2

print(add(1,2))

# global
def add(value1, value2):
    global result
    result = value1 + value2

add(1, 2)
print(result)
```

`return`不做解释，`global`的方法很少用，但是用这种方法可以通过`global`来访问函数作用域之外的变量或者创建一个全局的变量

## Multiple return values
``` python
# bad
def profile():
    global name
    global age
    name = 'Danny'
    age = 42
profile()
print(name)
print(age)

# good
def profile():
    name = 'Danny'
    age = 42
    return (name, age)

print(profile())

# better
def profile():
    name = 'Danny'
    age = 42
    return name, age
print(profile())
```
1. 第一种方法可以运行达到我们的效果，但是禁止使用
2. 第二种方法就好，利用`tuple`数据结构来进行存储，返回多个参数
3. 这个方法与第二种相比较更加的pythonic

总结：利用`tuple`，`list`，`dict`解决多参数返回的问题

## tips 9 mutation

``` python
foo = ['hi']
print(foo)

bar = foo
bar += ['bye'] # bar与foo是相同的
print(foo)

# bad bad bad target随着函数引用被初始化，这样将会一直对同一个list进行append操作
def add_to(num, target=[]):
    target.append(num)
    return target

# great
def add_to(num, target=None):
    if target is None:
        target = []
    target.append(num)
    return target
```

## tips 10 \_\_slots\_\_ Magic

``` python
# good
class MyClass(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age
        self.set_up()
    # ...

# better
class MyClass(object):
    __slots__ = ['name', 'age']
    def __init__(self, name, age):
        self.name = name
        self.age = age
        self.set_up()
    # ...
```
why the second code is better?
It involves the usage of `__slots__` to tell Python not to use a dict, and only allocate space for a fixed set of attributes. The second piece of code will reduce the burden on your RAM. Some people have seen almost 40 to 50% reduction in RAM usage by using this technique.