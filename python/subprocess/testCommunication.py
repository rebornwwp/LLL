# encoding=utf-8
# p.communicate可以与新进程交互，但是必须要在popen构造时候将管道重定向。

def TestCommunicate():
    import subprocess
    cmd = "ls"
    p=subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    (stdoutdata, stderrdata) = p.communicate()

    if p.returncode != 0:
        print (cmd + "error !")

    #defaultly the return stdoutdata is bytes, need convert to str and utf8
    for r in str(stdoutdata).split("\n"):
        print (r)
        print (p.returncode)

def TestCommunicate2():
    import subprocess
    cmd = "ls"
    #universal_newlines=True, it means by text way to open stdout and stderr
    p = subprocess.Popen(cmd, shell=True, universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    curline = p.stdout.readline()
    while(curline != ""):
        print (curline)
        curline = p.stdout.readline()
    p.wait()
    print (p.returncode)


TestCommunicate()
TestCommunicate2()

