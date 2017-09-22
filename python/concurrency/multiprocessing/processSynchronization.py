from multiprocessing import Process, Lock

# 通过lock可以控制这段代码每个时间节点，只能执行一次
def f(l, i):
    l.acquire()
    try:
        print("hello world", i)
    finally:
        l.release()


if __name__ == "__main__":
    lock = Lock()
    for num in range(10):
        Process(target=f, args=(lock, num)).start()
