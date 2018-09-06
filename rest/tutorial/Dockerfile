# base container
FROM python:3.6

# 将输出直接在终端显示，而不是缓存起来
ENV PYTHONUNBUFFERED 1

# 创建根目录
RUN mkdir /tutorial

# 设置工作目录
WORKDIR /tutorial

# 复制当前目录的内容到容器的/tutorial目录下
ADD . /tutorial

# 安装项目依赖的包
RUN pip install -r requirements.txt