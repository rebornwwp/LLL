# encoding=utf-8
# p.wait函数使得父进程等待新创建的进程运行结束，然后再继续父进程的其他任务。且此时可以在p.returncode中得到新进程的返回值。
def TestWait():
  import subprocess
  import datetime
  print(datetime.datetime.now())
  p=subprocess.Popen("sleep 10",shell=True)
  p.wait()
  print(p.returncode)
  print(datetime.datetime.now())


if __name__ == '__main__':
    TestWait()

