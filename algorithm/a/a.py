n, k = [int(i) for i in raw_input().split()]

l = set([n])

count = 0
while 1 not in l and k > 0:
    temp = set()
    for i in l:
        if i & 1 == 1:
            temp.add(i // 2)
            temp.add(i // 2 + 1)
        else:
            temp.add(i//2)
    l = temp
    count += 1
    k -= 1

count += max(l)
print(count)
