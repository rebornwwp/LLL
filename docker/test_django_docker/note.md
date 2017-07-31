1. 创建Dockerfile
2. 创建docker-compose.yml
3. 使用命令docker-compose run web django-admin.py startproject django_example .
    1. 首先创建web服务的镜像
    2. 在这镜像上运行django-admin.py startproject django_example .
    3. 这一大步主要由Dockerfile完成
4. 使用命令docker-compose up, 主要由docker-compose.完成(及运行)
