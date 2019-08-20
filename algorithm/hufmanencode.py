s = input()


class Node:
    def __init__(self, value):
        self.value = value
        self.string = ""
        self.left = None
        self.right = None


d = dict()

for i in s:
    if i in d:
        d[i] += 1
    else:
        d[i] = 1

l = []
for k, v in d.items():
    node = Node(v)
    node.string = k
    l.append(node)

while len(l) > 1:
    l = sorted(l, key=lambda x: x.value)
    min1 = l.pop(0)
    min2 = l.pop(0)
    new_node = Node(min1.value + min2.value)
    new_node.left = min1
    new_node.right = min2
    l.append(new_node)

m = dict()


def dfs(node, tmp, d):

    if node.left is None and node.right is None:
        d[node.string] = tmp
        return

    dfs(node.left, tmp + "0", d)
    dfs(node.right, tmp + "1", d)


dfs(l[0], "", d)

ans = 0
for i in s:
    ans += len(d[i])

print(ans)

