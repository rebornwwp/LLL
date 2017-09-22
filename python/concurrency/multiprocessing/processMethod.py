"""
set_start_method,直接将模块的method修改
get_context: 创建一个新的环境，和原来的multiprocessing有着相同的api
"""
import multiprocessing as mp

def f(q):
    q.put("hello")

def main():
    mp.set_start_method('forkserver')
    q = mp.Queue()
    p = mp.Process(target=f, args=(q,))
    p.start()
    print(q.get())
    p.join()

if __name__ == "__main__":
    main()
