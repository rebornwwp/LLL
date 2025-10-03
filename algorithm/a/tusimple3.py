# 图森未来最近购入了一批服务器，他们大小分别是2*4，4*8，8*16......(2^k)*(2^(k+1)),即每台服务器都恰好可以被四台比它们更小的服务器代替
# 现在，公司的员工小兔被分配一个任务，那就是根据小森给的服务器分配方式文档安排服务器的位置
# 文档
# 每一行都以两个字母和一个半角冒号开头，字母"NW", "NE", "SW", "SE"中的一个，且在同一层级不会重复
# "NW" "NE", "SW", "SR"分别代表当前层级的左上角，右上角，左下角，右下角位置，即上方为北方，右方为东，
# 冒号后又一个空格和"0", "X" 中的一个字母，则表示这一行是当前层级的一台服务器。
# 若冒号后没有任何内容，则接下来的若干行一定比当前行多两个空格缩进，且被缩进的行除缩进外也符合以上全部规则。
# 缩进可以嵌套

# input
# NE: O
# NW: X
# SW: O
# SE:
#   NE: O
#   NW:
#     NE: O
#     NW: X
#     SW: X
#     SE: O
#   SW: O
#   SE: X

# output
# +---------------+---------------+
# |               |               |
# |               |               |
# |               |               |
# |       X       |       O       |
# |               |               |
# |               |               |
# |               |               |
# +---------------+---+---+-------+
# |               | X | O |       |
# |               +---+---|   O   |
# |               | X | O |       |
# |       O       +-------+-------+
# |               |       |       |
# |               |   O   |   X   |
# |               |       |       |
# +---------------+-------+-------+


lines = []
while True:
    try:
        line = input()
        lines.append(line)
    except Exception:
        break


class TreeNode:
    def __init__(self, value):
        self.value = value
        self.NE = None
        self.NW = None
        self.SE = None
        self.SW = None


def parse(lines, t):
    for _ in range(4):
        line = lines.pop(0)

        dir, notation = line.strip().split(':')
        if len(notation) == 0:
            setattr(t, dir, TreeNode(None))
            parse(lines, getattr(t, dir))
        else:
            setattr(t, dir, TreeNode(notation.strip()))


t = TreeNode(None)

parse(lines, t)


def get_depth(t):
    if t.value is not None:
        return 1
    attrs = ['NW', 'NE', 'SW', 'SE']
    result = 0
    for attr in attrs:
        result = max(result, 1 + get_depth(getattr(t, attr)))
    return result


depth = get_depth(t)
result = [['' for _ in range(2 ** (depth + 1) + 1)]
          for _ in range(2 ** depth + 1)]


def print_to_result(i, j, t, depth, result):

    if t.value is not None:
        for x in range(i, i + 2 ** depth):
            for y in range(j, j + 2 ** (depth + 1)):
                if x == i and y == j:
                    result[x][y] = '+'
                elif x == i and y > j:
                    result[x][y] = '-'
                elif x > i and y == j:
                    result[x][y] = '|'
                else:
                    result[x][y] = ' '
        result[i + 2 ** (depth - 1)][j + 2 ** (depth)] = t.value
        return

    attrs = ['NW', 'NE', 'SW', 'SE']

    for attr in attrs:
        attr_t = getattr(t, attr)

        if attr == 'NW':
            x = i
            y = j
        elif attr == 'NE':
            x = i
            y = j + 2 ** depth
        elif attr == 'SW':
            x = i + 2 ** (depth - 1)
            y = j
        elif attr == 'SE':
            x = i + 2 ** (depth - 1)
            y = j + 2 ** depth
        print_to_result(x, y, attr_t, depth - 1, result)


print_to_result(0, 0, t, depth, result)

last_row = len(result) - 1
last_col = len(result[0]) - 1

for row in range(0, last_row + 1):
    if result[row][last_col - 1] != ' ':
        result[row][last_col] = '+'
    else:
        result[row][last_col] = '|'

for col in range(0, last_col + 1):
    if result[last_row - 1][col] != ' ':
        result[last_row][col] = '+'
    else:
        result[last_row][col] = '-'

for line in result:
    print(''.join(line))

