def mergeOrderedLists(l1, l2):
    i = 0
    j = 0
    l = []
    while i < len(l1) and j < len(l2):
        if l1[i] < l2[j]:
            l.append(l1[i])
            i += 1
        else:
            l.append(l2[j])
            j += 1

    while i < len(l1):
        l.append(l1[i])
        i += 1

    while j < len(l2):
        l.append(l2[j])
        j += 1

    return l


def mergeSort(theList):
    if len(theList) <= 1:
        return theList
    else:
        mid = len(theList) // 2
        leftList = mergeSort(theList[:mid])
        rightList = mergeSort(theList[mid:])

        newList = mergeOrderedLists(leftList, rightList)
        return newList

if __name__ == '__main__':
    l1 = [1, 3, 5, 7, 9]
    l3 = [1, 3, 5, 7, 9]
    l2 = [2, 4, 6, 8, 10]
    newList1 = mergeOrderedLists(l1, l2)
    newList2 = mergeOrderedLists(l1, l3)
    print(newList2)
    print(newList1)

    l4 = [9, 8, 7, 6, 5, 4, 3, 2, 1]
    newList3 = mergeSort(l4)
    print(newList3)
