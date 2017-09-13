from multiprocessing import Process, Lock

def f(l, i):
    print("hello world", i)


if __name__ == "__main__":
    lock = Lock()
    for num in range(100):
        Process(target=f, args=(lock, num)).start()
