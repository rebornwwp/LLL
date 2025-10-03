m, n = [int(i) for i in input().split()]


nums = [int(i) for i in input().split()]

d = dict()
buffer = []

i = 0
count = 0
for num in nums:
    if num not in d:
        d[num] = True
        count += 1
        if len(buffer) < m:
            buffer.append(num)
        else:
            i = i % m
            tmp = buffer[i]
            buffer[i] = num
            del d[tmp]
            i += 1

print(count)
