# virtualenv

```
# 安装
pip install virtualenv

# 使用
virtualenv [虚拟环境名称-也是目录名称]

# 启动
cd ENV
source ./bin/activate

# 不依赖相关库
virtualenv --no-site-packages [虚拟环境名称]

# 退出
deactivate
```

# Virtualenvwrapper
Virtaulenvwrapper是virtualenv的扩展包，用于更方便管理虚拟环境，它可以做：

1. 将所有虚拟环境整合在一个目录下
2. 管理（新增，删除，复制）虚拟环境
3. 快速切换虚拟环境

```
# 安装
pip install virtualenvwrapper

# 创建目录用来存放虚拟环境
mkdir ~/.virtualenvs

# 在.bashrc中添加
export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

# 运行
source ~/.bashrc

命令列表

workon:列出虚拟环境列表

lsvirtualenv:同上

mkvirtualenv :新建虚拟环境

workon [虚拟环境名称]:切换虚拟环境

rmvirtualenv :删除虚拟环境

deactivate: 离开虚拟环境
```
