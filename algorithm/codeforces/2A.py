n = int(input())

d = dict()

reach_first = dict()
max_score = 0

rounds = []
while n > 0:
    n -= 1
    name, score = input().split()
    rounds.append((name, int(score)))
    if name in d:
        d[name] += int(score)
    else:
        d[name] = int(score)

all_scores = sorted(list(d.items()), key=lambda x: x[1], reverse=True)
candidates = [i[0] for i in all_scores if i[1] == all_scores[0][1]]
m = all_scores[0][1]

temp = dict()
for name, score in rounds:
    if name not in temp:
        temp[name] = score
    else:
        temp[name] += score
    if name in candidates and temp[name] >= m:
        print(name)
        break
