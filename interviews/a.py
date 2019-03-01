# 1, 校验IP地址是否在CIDR范围内

# 我们一般用CIDR来表示一段ip地址。CIDR是这样一个字符串：先是一个ipv4的地址的字符串表示，加一个”/“分隔符，再加一个13（含）到27（含）之间的整数。比如“192.128.1.134/25”，表示从192.128.1.128（含）到192.128.1.255（含）的128个ip地址。

# ”/“前的字段“192.128.1.134”表示该范围内的一个ip地址（不一定是第一个ip地址）。

# “/“之后的整数“25”表示该地址段里的所有ip地址的二进制形式，前25个bit都是相同的，也就是都是”1100 0000   1000 0000  0000 0001 1” 。

# 输入：给定一个ip地址和一个CIDR

# 输出：如果ip在CIDR内，输出true。不然，输出false

# Java 函数可以是这样的：

# boolean checkIPinCIDR(String ip, String cidr)

# 11000000.10000000.000000001.10000000
# 11000000.10000000.000000001.11111111
# 只要前ip和cidr的二进制前length位数相同就好了


def checkIPinCIDR(ip, cidr):
    ips = [int(num) for num in ip.split('.')]
    ips[0] = ips[0] << 24
    ips[1] = ips[1] << 16
    ips[2] = ips[2] << 8
    network_prefix, length = cidr.split('/')
    network_prefixs = [int(num) for num in network_prefix.split('.')]
    network_prefixs[0] = network_prefixs[0] << 24
    network_prefixs[1] = network_prefixs[1] << 16
    network_prefixs[2] = network_prefixs[2] << 8
    helper_number = 0xFFFFFFFF << (32 - int(length))
    return (helper_number & sum(ips)) == (helper_number & sum(network_prefixs))

if __name__ == "__main__":
    print(checkIPinCIDR("192.128.1.128", "192.128.1.134/25"))
    print(checkIPinCIDR("192.128.1.127", "192.128.1.134/25"))
