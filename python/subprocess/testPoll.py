# encoding=utf-8
# p.poll函数可以用来检测新创建的进程是否结束。
def TestPoll():
  import subprocess
  import datetime
  import time
  print (datetime.datetime.now())
  p = subprocess.Popen("sleep 10",shell=True)
  t = 1
  while(t <= 5):
    time.sleep(1)
    p.poll()
    print (p.returncode)
    t += 1
  print (datetime.datetime.now())

TestPoll()

