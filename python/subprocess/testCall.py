# encoding=utf-8

# call函数可以认为是对popen和wait的分装，直接对call函数传入要执行的命令行，将命令行的退出code返回。

def TestCall():
    import subprocess
    retcode = subprocess.call("ls")
    print (retcode)

TestCall()

