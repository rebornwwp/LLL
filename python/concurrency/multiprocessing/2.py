import timeit
import platform
import numpy as np
import multiprocessing as mp

np.random.seed(123)

# Generate random 2D-patterns
mu_vec = np.array([0, 0])
cov_mat = np.array([[1, 0], [0, 1]])
x_2Dgauss = np.random.multivariate_normal(mu_vec, cov_mat, 10000)


def parzen_estimation(x_samples, point_x, h):
    k_n = 0
    for row in x_samples:
        x_i = (point_x - row[:, np.newaxis]) / h
        for row in x_i:
            if np.abs(row) > (1 / 2):
                break
            else:
                k_n += 1
    return (k_n / len(x_samples)) / (h**point_x.shape[1])


def serial(samples, x, widths):
    return [parzen_estimation(samples, x, w) for w in widths]


def multiprocess(processes, samples, x, widths):
    pool = mp.Pool(processes=processes)
    results = [
        pool.apply_async(parzen_estimation, args=(samples, x, w))
        for w in widths
    ]
    results = [p.get() for p in results]
    results.sort()
    return results


widths = np.arange(0.1, 1.3, 0.1)
point_x = np.array([[0], [0]])
results = []

number = 10
benchmarks = []
benchmarks.append(
    timeit.Timer(
        'serial(x_2Dgauss, point_x, widths)',
        'from __main__ import serial, x_2Dgauss, point_x, widths').timeit(
            number=number))

benchmarks.append(
    timeit.Timer(
        'multiprocess(2, x_2Dgauss, point_x, widths)',
        'from __main__ import multiprocess, x_2Dgauss, point_x, widths').
    timeit(number=number))

benchmarks.append(
    timeit.Timer(
        'multiprocess(3, x_2Dgauss, point_x, widths)',
        'from __main__ import multiprocess, x_2Dgauss, point_x, widths').
    timeit(number=number))

benchmarks.append(
    timeit.Timer(
        'multiprocess(4, x_2Dgauss, point_x, widths)',
        'from __main__ import multiprocess, x_2Dgauss, point_x, widths').
    timeit(number=number))

benchmarks.append(
    timeit.Timer(
        'multiprocess(5, x_2Dgauss, point_x, widths)',
        'from __main__ import multiprocess, x_2Dgauss, point_x, widths').
    timeit(number=number))

benchmarks.append(
    timeit.Timer(
        'multiprocess(6, x_2Dgauss, point_x, widths)',
        'from __main__ import multiprocess, x_2Dgauss, point_x, widths').
    timeit(number=number))

benchmarks.append(
    timeit.Timer(
        'multiprocess(10, x_2Dgauss, point_x, widths)',
        'from __main__ import multiprocess, x_2Dgauss, point_x, widths').
    timeit(number=number))


def print_sysinfo():
    print('\nPython version :', platform.python_version())
    print('compiler         :', platform.python_compiler())
    print('\nsystem         :', platform.system())
    print('release          :', platform.release())
    print('machine          :', platform.machine())
    print('processes        :', platform.processor())
    print('CPU count        :', mp.cpu_count())
    print('interpreter      ', platform.architecture())
    print('\n\n')


print_sysinfo()
labels = ['serial', 2, 3, 4, 5, 6, 10]

for label, time in zip(labels, benchmarks):
    print("{}:{}".format(label, time))
