"""
Consider a sequence u where u is defined as follows:

    The number u(0) = 1 is the first one in u.
    For each x in u, then y = 2 * x + 1 and z = 3 * x + 1 must be in u too.
    There are no other numbers in u.
    Ex: u = [1, 3, 4, 7, 9, 10, 13, 15, 19, 21, 22, 27, ...]

    1 gives 3 and 4, then 3 gives 7 and 10, 4 gives 9 and 13, then 7 gives 15 and 22 and so on...

    #Task: Given parameter n the function dbl_linear (or dblLinear...) returns the element u(n) of the ordered (with <) sequence u.

    #Example: dbl_linear(10) should return 22

    #Note: Focus attention on efficiency
"""

def dbl_linear(n):
    # ai --> 2*x+1 序列的索引
    # bi --> 3*x+1 序列的索引
    # eq --> 重复item个数
    # 两个序列的合并
    ai, bi, eq = 0, 0, 0
    tmp = [1]
    while ai + bi < n + eq:
        x = 2 * tmp[ai] + 1
        y = 3 * tmp[bi] + 1
        if x > y:
            tmp.append(y)
            bi += 1
        elif x < y:
            tmp.append(x)
            ai += 1
        else:
            tmp.append(x)
            ai += 1
            bi += 1
            eq += 1
    return tmp[-1]

if __name__ == "__main__":
    print(dbl_linear(50))
