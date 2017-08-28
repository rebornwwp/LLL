# encoding=utf-8
# Popen启动新的进程与父进程并行执行，默认父进程不等待新进程结束。
def TestPopen():
  import subprocess
  p=subprocess.Popen("ls",shell=True)
  for i in range(250) :
    print ("other things")


if __name__ == '__main__':
    TestPopen()

