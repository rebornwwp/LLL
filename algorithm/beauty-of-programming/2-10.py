# 寻找数组中的最大值和最小值


def findMaxMin(l):
    if len(l) == 0:
        return (0, 0)
    min, max = l[0], l[0]
    for i in l:
        if i > max:
            max = i
        elif i < min:
            min = i
    return (min, max)


def findMaxMin1(l):
    if len(l) == 0:
        return (0, 0)
    min, max = l[0], l[0]
    for i in range(len(l)):
        if i < len(l) - 1:
            if l[i] > l[i + 1]:
                min_num = l[i + 1]
                max_num = l[i]
            else:
                min_num = l[i]
                max_num = l[i + 1]
            if min > min_num:
                min = min_num
            if max < max_num:
                max = max_num
    return (min, max)


def findMaxMin2(l, b, e):
    if e - b <= 1:
        if l[b] < l[e]:
            return (l[b], l[e])
        else:
            return (l[e], l[b])
    minL, maxL = findMaxMin2(l, b, b + (e - b) // 2)
    minR, maxR = findMaxMin2(l, b + (e - b) // 2 + 1, e)
    minAll = min(minL, minR)
    maxAll = max(maxL, maxR)
    return (minAll, maxAll)


if __name__ == "__main__":
    print(findMaxMin([1, 2, 3, 4, 5]))
    print(findMaxMin1([1, 2, 3, 4, 5]))
    print(findMaxMin2([1, 2, 3, 4, 5], 0, 4))
    print(findMaxMin([1, 2, 3, 4, 5, 6]))
    print(findMaxMin1([1, 2, 3, 4, 5, 6]))
    print(findMaxMin2([1, 2, 3, 4, 5, 6], 0, 5))
