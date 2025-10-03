# 写一个程序，求两个正整数的最大公约数。如果两个正整数都很大，有什么简单的算法呢？


# 解法1
def gcd(x, y):
    if y == 0:
        return x
    else:
        return gcd(y, x % y)


# 解法2 除法受限
def gcd1(x, y):
    if y == 0:
        return x
    elif x < y:
        return gcd1(y, x)
    else:
        return gcd1(x - y, y)


# 解法3
def gcd2(x, y):
    if y == 0:
        return x
    elif x < y:
        return gcd2(y, x)
    else:
        if x & 1 == 0:
            if y & 1 == 0:
                return (gcd2(x >> 1, y >> 1) << 1)
            else:
                return gcd2(x >> 1, y)
        else:
            if y & 1 == 0:
                return gcd2(x, y >> 1)
            else:
                return gcd2(y, x - y)


if __name__ == "__main__":
    print(gcd(12, 6))
    print(gcd1(12, 6))
    print(gcd2(12, 6))
