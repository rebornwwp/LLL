# 问题 
```
# 1
uuid4直接用assertEqual，报错，我的做法是转化成字符串
faker生成的uuid4是一个字符串
```

```
Traceback (most recent call last):
  File "/Users/staff/.virtualenvs/django_env/lib/python2.7/site-packages/django/core/handlers/exception.py", line 41, in inner
    response = get_response(request)
  File "/Users/staff/.virtualenvs/django_env/lib/python2.7/site-packages/django/core/handlers/base.py", line 187, in _get_response
    response = self.process_exception_by_middleware(e, request)
  File "/Users/staff/.virtualenvs/django_env/lib/python2.7/site-packages/django/core/handlers/base.py", line 185, in _get_response
    response = wrapped_callback(request, *callback_args, **callback_kwargs)
  File "/Users/staff/.virtualenvs/django_env/lib/python2.7/site-packages/django/views/decorators/csrf.py", line 58, in wrapped_view
    return view_func(*args, **kwargs)
  File "/Users/staff/.virtualenvs/django_env/lib/python2.7/site-packages/django/views/generic/base.py", line 68, in view
    return self.dispatch(request, *args, **kwargs)
  File "/Users/staff/.virtualenvs/django_env/lib/python2.7/site-packages/rest_framework/views.py", line 489, in dispatch
    response = self.handle_exception(exc)
  File "/Users/staff/.virtualenvs/django_env/lib/python2.7/site-packages/rest_framework/views.py", line 449, in handle_exception
    self.raise_uncaught_exception(exc)
  File "/Users/staff/.virtualenvs/django_env/lib/python2.7/site-packages/rest_framework/views.py", line 477, in dispatch
    self.initial(request, *args, **kwargs)
  File "/Users/staff/.virtualenvs/django_env/lib/python2.7/site-packages/rest_framework/views.py", line 395, in initial
    self.check_permissions(request)
  File "/Users/staff/.virtualenvs/django_env/lib/python2.7/site-packages/rest_framework/views.py", line 327, in check_permissions
    for permission in self.get_permissions():
  File "/Users/staff/.virtualenvs/django_env/lib/python2.7/site-packages/rest_framework/views.py", line 274, in get_permissions
    return [permission() for permission in self.permission_classes]
TypeError: 'type' object is not iterable
上面最后看最后一句[permission() for permission in self.permission_classes]
我们在程序中加入了一个变量，但是这个变量是不可遍历的。
我的程序中出错的地方是我将一个set初始化的时候出错：
我的
permission_classes = (permissions.IsAuthenticated)
正确的应该是
permission_classes = (permissions.IsAuthenticated, )
```





