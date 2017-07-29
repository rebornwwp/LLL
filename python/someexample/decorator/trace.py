import functools

def trace(func):
    '''
    打印函数参数，和函数执行之后的结果
    '''
    @functools.wraps(func)
    #上面装饰器可以帮助保护内部内省机制，比如这个是不会让help函数失效
    #还能保护标准python属性，如__module__, __name__属性经过修饰函数后不变
    def wrapper(*args, **kwargs):
        result = func(*args, **kwargs)
        print('%s(%r, %r) -> %r' % (func.__name__, args, kwargs, result))
        return result
    return wrapper


#@trace 与 trace(fibonacci)一样的效果
@trace
def fibonacci(n):
    '''
    return the n-th fibonacci number
    '''
    if n in (0, 1):
        return n
    return (fibonacci(n-1) + fibonacci(n-2))


fibonacci(3)
print(fibonacci)
print(fibonacci.__name__)
print(fibonacci.__module__)


print(help(fibonacci))
