# encoding=utf-8
# p.kill或p.terminate用来结束创建的新进程，在windows系统上相当于调用TerminateProcess()，在posix系统上相当于发送信号SIGTERM和SIGKILL。

def TestKillAndTerminate():
    import subprocess
    import time
    p=subprocess.Popen("sleep 20", shell=True)
    t = 1
    while(t <= 5):
      time.sleep(1)
      t +=1
    p.kill()
    # p.terminate()
    print ("new process was killed")


TestKillAndTerminate()

