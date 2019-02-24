import multiprocessing as mp
import random
import string
import time

random.seed(1234)

output = mp.Queue()


def rand_string(length, pos, output):
    rand_str = ''.join(
        random.choice(string.ascii_lowercase + string.ascii_uppercase +
                      string.digits) for i in range(length))
    output.put((pos, rand_str))


processes = [
    mp.Process(target=rand_string, args=(10, x, output)) for x in range(10)
]

for p in processes:
    p.start()

for p in processes:
    p.join()

results = [output.get() for p in processes]

# 多进程结果会让结果不是顺序的, 如何获取顺序结果呢，
# 1. 将要运行的多进程任务，传入一个参数，代表第几个进程，然后对返回的结果排序。
sort_results = results.sort(key=lambda t: t[1])
print(results)


def rand_string1(length, pos, sleep=False):
    rand_str = ''.join(
        random.choice(string.ascii_uppercase + string.ascii_lowercase +
                      string.digits) for i in range(length))
    if sleep:
        time.sleep(random.randint(0, 10))
    return (pos, rand_str)


def cube(x):
    time.sleep(random.randint(0, 5))
    return x**3


# 进程数代表能够同时间运行的最大进程数
# 通过pool类apply来执行的进程结果会按照顺序返回
pool = mp.Pool(processes=5)
results = [pool.apply(rand_string1, args=(5, x)) for x in range(1, 7)]

print(results)

# 痛殴Pool类map方法来执行进程结果按照顺序返回
# results = pool.map(cube, range(1, 7))
# print(results)

# 上面的不带有async，上面的方法将知道所以进程结束才会返回结果。

results = [pool.apply_async(cube, args=(x, )) for x in range(1, 7)]
output = [p.get() for p in results]
print(output)
