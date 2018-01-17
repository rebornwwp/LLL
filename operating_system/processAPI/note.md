# 1
1. https://github.com/mit-pdos/xv6-public
## 6
CPU 虚拟化是通过time sharing实现的
实现虚拟化机制，主要有下面两个问题
1. 一个是性能，虚拟化肯定要消耗系统资源，那么消耗的资源是不是会过多的加重系统的负担
2. 另外一个是控制，如何在保留os对cpu控制的同时，实现程序高效运行，cpu的资源还是很宝贵的，没有对cpu进行控制的话，可能一个程序将会一直进行下去，并且接管整个机器。
虚拟化的主要挑战:Obtaining high performance while maintaining control is thus one of the central challenges in building an operating system.

可以这样试想，我有一把小刀，现在有个陌生人想借我这把小刀用，我可以相当于os，小刀cpu，陌生人进程，我一定要保留对到的最终控制权，叫陌生人还给我刀就还给我刀，而且我还需要在
陌生人傍边指导他小刀该怎么用，这样才能让他尽快用完小刀，并且归还。


### 6.1 Basic Technique: Limited Direct Execution
#### Direct Execution Protocol (Without Limits)
1. Create entry for process list
2. Allocate memory for program
3. Load program into memory
4. Set up stack with argc/argv
5. Clear registers
6. Execute call main()
    1. Run main()
    2. Execute return from main
7. Free memory of process
8. Remove from process list

上面是在没有限制条件下的直接执行进程。但这样的方式存在一些问题
1. 如何保证在高效运行程序的同时，保证我们的系统能够让程序做一些我们不想让它做的事。
2. 当运行一个进程的时候，怎么停止这个进程，转换到其他进程。
