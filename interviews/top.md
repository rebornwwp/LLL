# top 指令各参数的意义

## system time, uptime and user sessions
top - 17:32:47 up 2 days, 11 min, 26 users,
在top指令的左上角，显示当前时间，up之后的时间代表着系统已经运行了多长时间。
之后的26users说明了，当前有多少活跃的用户session

## memory usage
KiB Mem : 65851904 total,   764532 free,  5251812 used, 59835560 buff/cache
KiB Swap:  1000444 total,  1000444 free,        0 used. 56820624 avail Mem

上面的说明了现在的内存使用情况。

1. Mem 代表RAM的空间
2. swap 代表swap空间 a swap space is a part of the hard disk that is used like RAM. 

当内存没有可用的，就必须要把内存中不经常运行的程序给踢出去。但是踢到哪里去，这时候swap就出现了

## tasks
Tasks: 592 total,   2 running, 416 sleeping,   1 stopped,   0 zombie

统计，反应了系统有总的进程数，正在运行的进程数， 有多少sleeping 进程，sleeping进程分为：Interruptible sleep
Uninterruptible sleep. 被停止的进程，和僵尸进程。

僵尸进程：一个进程使用fork创建子进程，如果子进程退出，而父进程并没有调用wait或waitpid获取子进程的状态信息，那么子进程的进程描述符仍然保存在系统中。这种进程称之为僵死进程。

孤儿进程：一个父进程退出，而它的一个或多个子进程还在运行，那么那些子进程将成为孤儿进程。孤儿进程将被init进程(进程号为1)所收养，并由init进程对它们完成状态收集工作。

load average:0.24, 0.15, 0.19 — load average后面的三个数分别是5分钟、10分钟、15分钟的负载情况。

这里显示不同模式下所占cpu时间百分比，这些不同的cpu时间表示：
1. us, user： 运行(未调整优先级的) 用户进程的CPU时间
2. sy，system: 运行内核进程的CPU时间
3. ni，niced：运行已调整优先级的用户进程的CPU时间
4. wa，IO wait: 用于等待IO完成的CPU时间
5. hi：处理硬件中断的CPU时间
6. si: 处理软件中断的CPU时间
7. st：这个虚拟机被hypervisor偷去的CPU时间（译注：如果当前处于一个hypervisor下的vm，实际上hypervisor也是要消耗一部分CPU处理时间的）。

PID：进程ID，进程的唯一标识符

USER：进程所有者的实际用户名。

PR：进程的调度优先级。这个字段的一些值是'rt'。这意味这这些进程运行在实时态。

NI：进程的nice值（优先级）。越小的值意味着越高的优先级。负值表示高优先级，正值表示低优先级

VIRT：进程使用的虚拟内存。进程使用的虚拟内存总量，单位kb。VIRT=SWAP+RES

RES：驻留内存大小。驻留内存是任务使用的非交换物理内存大小。进程使用的、未被换出的物理内存大小，单位kb。RES=CODE+DATA

SHR：SHR是进程使用的共享内存。共享内存大小，单位kb

### top命令 CPU利用率超过100%?

linux top命令显示的CPU百分比是以其单个核数为单位的，即一个核为100%，两个核是200%，然后以此类推。如果你的进程利用了多个cpu，那么top命令显示的是多个cpu占用率的总和。
