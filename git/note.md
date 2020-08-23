# git log

``` 
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
# 只用git lg 就能实现功能
```

# 跟新代码到最新

``` 
git pull
```

# 代码状态

每一个文件都不外乎这两种状态：已跟踪或未跟踪。 已跟踪的文件是指那些被纳
入了版本控制的文件，在上一次快照中有它们的记录，在工作一段时间后，它们的
状态可能处于未修改，已修改或已放入暂存区。

# 代码比较

``` 
# 代码在工作区中的比较，修改了但是代码没有加入到暂存区
git diff

# 已修改的代码放入了暂存区的比较
git diff --cached
# or
git diff --staged
```

# 撤销操作

## 修改上次commit的内容

``` 
# 没有文件暂存区与有文件加入暂存区时都是用
git commit --amend
```

## 取消暂存区的文件

``` 
# 有一个readme.md的文件加入了暂存区，我们现在撤销暂存
git reset HEAD readme.md
```

## 撤销对文件的修改

``` 
# 此时文件并没有加入到暂存区中，只是跟踪状态下文件状态为已修改，现在我们想将代码变成未修改的状态
git checkout -- <file>
```

# 远程仓库的使用

## 查看远程仓库

``` 
git remote
git remote -v
```

## 添加远程仓库

``` 
git remote add <shortname> <url>
git remote add pb https://github.com/paulboone/ticgit

# 其他人拉取这个仓库
git fetch pb
```

## 从远程仓库中抓取与拉取

``` 
git fetch [remote-name]
```

## 推送到远程仓库

``` 
git push [remote-name] [branch-name]
```

## 查看远程仓库的更多信息

``` 
git remote show [remote-name]
```

## 远程仓库的移除与重命名

``` 
git remote rename pb paul

git remote rm paul
```

# 打标签

## 列出标签

``` 
git tag

# 模式匹配
git tag -l 'v1.8.5*'
```

## 创建标签

Git 使用两种主要类型的标签：轻量标签（lightweight）与附注标签（annotated）。

一个轻量标签很像一个不会改变的分支 - 它只是一个特定提交的引用。

然而，附注标签是存储在 Git 数据库中的一个完整对象。 它们是可以被校验的；其中包含打标签者的名字、电子邮件地址、日期时间；还有一个标签信息；并且可以使用 GNU Privacy Guard （GPG）签名与验证。 通常建议创建附注标签，这样你可以拥有以上所有信息；但是如果你只是想用一个临时的标签，或者因为某些原因不想要保存那些信息，轻量标签也是可用的。

##  附注标签

``` 
git tag -a v1.4 -m 'my version  1.4'

# 显示指定标签信息
git show v1.4
```

## git别名

``` 
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
```

# 分支介绍

## 创建分支

``` 
git branch [branch-name]
```

## 切换分支

``` 
git checkout -b [branch-name]

# 下面两个命令可以代替上面的一条命令
git branch [branch-name]
git chekcout [branch-name]
```

## 分支合并

``` 
# 将其他分支合并到master分支
# master
git checkout master
git merge other-branch

# 如果合并分支没有出现冲突，之后就将我们合并过的分支删除
git branch -d had-merged-branch

# 如果合并之后有冲突,手动修改合并之后有冲突部分的代码
# 有冲突部分的代码用<<<<<<< , ======= , 和 >>>>>>>分割开来，
# 手动解决冲突之后，将代码add commit就好了
```

## 分支管理

``` 
# list all branch
git branch

# 查看每一个分支的最后一次提交
git branch -v

# 查看哪些分支已经合并到当前分支
git branch --merged
# 查看所有包含未合并工作的分支
git branch --no-merged

# delete a branch
git branch -d branch-name
```

# 场景说明及操作

有a和b两个commit（都为git push到远程代码仓库），a在b之前，我们想做的是撤销b，然后将b所做的修改一并commit到a上？

做法

``` bash
git reset --soft HEAD^

# 查看暂存区
git status .

# commit
git commit --amend
```
