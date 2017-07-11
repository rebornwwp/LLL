# 问题1
```
Django: TemplateDoesNotExist (rest_framework/api.html)

需要在站点前面的INSTALLED_APP里面加上rest_framework
```

#问题2
```
no such table: tablename, 
django中模型到到数据中的映射将变成appname_modelname的形式

上面这个问题说明是说明数据库中无法同步，发现是自己删除了app中migrations目录的原因，所以只要有这个目录并且在目录下有__init__.py文件就能够重新makemigrations了
```
