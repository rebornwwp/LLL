# 写一个函数f(N)，返回1到N之前出现“1”的个数，比如f(12) = 5
# 满足f(N) = N的最大的N是多少?


# 方法一
def count1InAInteger(num):
    count = 0
    while num:
        if num % 10 == 1:
            count += 1
        num //= 10
    return count


def f(n):
    total = 0
    for i in range(1, n + 1):
        total += count1InAInteger(i)
    return total


# 方法二, 分别计算个位十位百位1出现的次数
def sum1s(n):
    icount = 0
    iFactor = 1
    iHighNumber = 0
    iLowNumber = 0
    iCurryNumber = 0
    while n // iFactor > 0:
        iHighNumber = n // (iFactor * 10)
        iLowNumber = n % iFactor
        iCurryNumber = n // iFactor % 10

        if iCurryNumber == 0:
            icount += iHighNumber * iFactor
        elif iCurryNumber == 1:
            icount += iHighNumber * iFactor + iLowNumber + 1
        else:
            # iCurryNumber between 2 and 9
            icount += iHighNumber * iFactor + iFactor
        iFactor *= 10

    return icount


if __name__ == '__main__':
    print(count1InAInteger(12))
    print(f(12))
    print(f(1000000))
    print(sum1s(1000000))
