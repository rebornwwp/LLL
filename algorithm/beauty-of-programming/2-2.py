# 不要被阶乘吓到
# 1 给定一个整数N，那么N的阶乘N! 末尾有多少个0呢？
# 2 求N! 的二进制表示中最低位1的位置


def f(n):
    count = 0
    for i in range(1, n + 1):
        j = i
        while j % 5 == 0:
            count += 1
            j = j // 5
    return count


def f2(n):
    count = 0
    while n:
        count += n // 5
        n //= 5
    return count


def lowestOne(n):
    count = 0
    while n:
        n >>= 1
        count += n
    return count


def lowestOne1(n):
    """N!含有的质因数2的个数等于N减去N的二进制表示中1的数目"""
    return n - count(n)


def count(n):
    num = 0
    while n:
        n &= (n - 1)
        num += 1
    return num


# 相关题目
# 给定整数n，判断它是否是2的方幂，提示(n > 0 && n &(n - 1) == 0) 其二进制表示中只有一个1


def isMi(n):
    return (n > 0) and (n & (n - 1) == 0)


if __name__ == '__main__':
    print(f(10))
    print(f2(10))
    print(lowestOne(27))
    print(lowestOne1(27))
    print(isMi(0x0111))
    print(isMi(0x0100))
