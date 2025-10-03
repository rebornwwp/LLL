# 二进制数中的1的个数
# 对于一个字节(8bit)的无符号整型变量，求其二进制表示中"1"的个数，要求算法的执行效率尽可能的高。


def count1(bit_num):
    """基本思路"""
    num = 0
    while bit_num > 0:
        if bit_num % 2 == 1:
            num += 1
        bit_num = bit_num // 2
    return num


def count2(bit_num):
    """位运算"""
    num = 0
    while bit_num > 0:
        num = bit_num & 0x01
        bit_num = bit_num >> 1
    return num


def coun3(bit_num):
    """
    v = 0100000 & 0011111
    v = 0
    v = v & (v - 1)
    上述操作总是将一个数的二进制表示中的最右边的1消除
    """
    num = 0
    while bit_num > 0:
        bit_num = bit_num & (bit_num - 1)
        num += 1
    return num


# 其他方法，查表法


# 平行算法
def count4(bit_num):
    v = (v & 0x55555555) + ((v >> 1) & 0x55555555)
    v = (v & 0x33333333) + ((v >> 2) & 0x33333333)
    v = (v & 0x0f0f0f0f) + ((v >> 4) & 0x0f0f0f0f)
    v = (v & 0x00ff00ff) + ((v >> 8) & 0x00ff00ff)
    v = (v & 0x0000ffff) + ((v >> 16) & 0x0000ffff)
    return v


def diffrentBits(num1, num2):
    bit = num1 ^ num2
    return count3(bit)


if __name__ == "__main__":
    print(count1(9))
    print(count2(9))
    print(count3(9))
