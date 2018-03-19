def quickSort(theseq):
    n = len(theseq)
    recQuickSort(theseq, 0, n - 1)


def recQuickSort(theseq, first, last):
    if first >= last:
        return
    else:
        pos = partionSeq(theseq, first, last)

        #自己的错误-1和+1未加上，这里pos为止已经排序好了所以不用排序了
        recQuickSort(theseq, first, pos-1)
        recQuickSort(theseq, pos+1, last)


def partionSeq(theseq, first, last):
    i = first + 1
    j = last

    while i < j:
        #print("the i is {}".format(i))
        #print("the j is {}".format(j))
        #错的是i < j和i<=j为加上，当后面的全部都是比第一个小的时候，i将会一直加
        #上去然后直到越界，同样当后面比第一个元素大的时候也会越界。
        while theseq[i] < theseq[first] and i < j:
            i += 1
        while theseq[j] >= theseq[first] and i <= j:
            j -= 1

        if i < j:
            theseq[i], theseq[j] = theseq[j], theseq[i]

        if j != first:
        	theseq[j], theseq[first] = theseq[first], theseq[j]

    return j


def test():
    a = [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
    s = partionSeq(a, 0, 9)
    quickSort(a)
    print(a)
    print(s)

if __name__ == '__main__':
    test()
