N, k = [int(i) for i in raw_input().split()]

l = [int(i) for i in raw_input().split()]


l = sorted(l)
i = 0

ans = []
accum = 0

while k > 0:
    if i < len(l):
        while i != 0 and l[i-1] == l[i]:
            i += 1
        ans.append(l[i] - accum)
        accum += (l[i] - accum)
    else:
        ans.append(0)
    i += 1
    k -= 1

for i in ans:
    print i
