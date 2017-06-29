# 学习网站

```
http://docs.datastax.com/en/cql/3.1/cql/cql_using/about_cql_c.html
```

# get started

1. 链接
2. 查询
    1. 普通查询
    2. 异步查询
3. 设置一致性
4. 准备语句

# object mapper

1. 定义models，并将其映射到表中
2. 查询，过滤
3. 批处理
4. 实验性质的链接
5. 第三方库，celery，uwsgi

```
# 连接的一个快速代码,关于数据库映射，添加，删除就可以快速实现
from cassandra.cqlengine.connection import setup
setup(['127.0.0.1'], 'db_name')
```

# paging large queries

# user defined types
已经在cassandra数据库中有了创建的新的type，但是python并不知道我们数据库中定义的类型是怎样的，
所以需要用python定义一个类，这样通过这个中间媒介，实现从python代码到数据库中数据的转化。

1. Registering a Class to Map to a UDT
2. Using UDTs Without Registering Them

# Security

1. Authentication
2. custom authenticators
3. protocol v1 authentication
4. ssl

# work with dates and times

