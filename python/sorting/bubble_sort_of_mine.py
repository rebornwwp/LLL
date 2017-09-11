def bubble_sort(L):
    """
    this is a bubble sort
    L: list
    """

    # swapped is meanning of whether the list is swapped, if not swapped
    # the list is sorted.
    swapped = True
    j = 0
    n = len(L)
    while(swapped):
        swapped = False
        j += 1
        for i in range(n - j):
            if(L[i] > L[i+1]):
                L[i], L[i+1] = L[i+1], L[i]
                swapped = True


if __name__ == '__main__':
    L = [6, 5, 4, 3, 2, 1]
    bubble_sort(L)
    print(L)
