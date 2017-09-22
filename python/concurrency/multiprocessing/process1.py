"""
multiprocessing中新开进程的方法有三个
1. spawn方法：父进程将会新开一个python解析器进程，这个子进程将会继承子进程中用到的父进程的资源
这样的话，父进程中不必要的文件描述和操作将不会被继承，所以此方法开进程比fork和forkserver方法慢
2. fork方法：只能在unix中用到，这个方法父进程中将通过os.fork()来创建一个新的python解析器进程，
子进程开始运行的时候，其和父进程等效，子进程将继承父进程中的所有资源，这相当于对同一个资源进行
利用了，所以从多进程中通过fork方法创建新进程将会是problematic
3. forkserver 通过forkserver方法，将会创建一个服务进程（server process），之后当每次需要一个新的
进程的时候，父进程将和这个服务进程连接，请求服务进程创建一个新的进程，因为服务进程是单线程的，所以
用os.fork()将总是安全的，并且没有不必要的资源被继承
"""
from multiprocessing import Process
import os


def info(title):
    print(title)
    print("module name ", __name__)
    print("parent process id ", os.getppid())
    print("process id ", os.getpid())

def f(name):
    print("f process id is ", os.getpid())
    print("hello ", name)

if __name__ == "__main__":
    print("main process id ", os.getpid())
    info('main line')
    p = Process(target=f, args=('bob',))
    p.start()
    p.join()
