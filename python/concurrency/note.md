# threading module

## threading.local

`threading.local`数据是由thread来确定的数据，其是通过`local`类或者其子类的实例，存储数据在其中来管理这个`threading-local`数据的。

``` python
import threading

mydata = threading.local()
mydata.x = 1
```

The instance’s values will be different for separate threads.

class threading.local
A class that represents thread-local data. 指明这是一个类，可以继承

For more details and extensive examples, see the documentation string of the `_threading_local` module.