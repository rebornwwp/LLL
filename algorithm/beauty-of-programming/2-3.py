# tango是微软亚洲研究院的一个实验项目，研究院的员工和实习生们都很喜欢在Tango上面交流灌水。传说
# ，tango有个大水王，他不但喜欢发帖，他会回复其他ID发的每个帖子，坊间风闻该“水王”发帖数目超过了
# 帖子总数的一半。如果你有一个当前论坛上所有帖子的（包括回帖）的列表，其中帖子作者的ID特在其中，
# 你能快速找出这个传说中的Tango水王吗？

# 方法1-统计


# 方法2-排序之后找到最中间的那个用户
def find2(ids):
    sorted_ids = sorted(ids)
    return sorted_ids[len(ids) // 2]


# 方法3-每次总是删除两个不同的ID(将帖子分为水王ID和其他人的ID)
def find3(ids):
    ntimes = 0
    for id in ids:
        if ntimes == 0:
            candidate = id
        else:
            if candidate == id:
                ntimes += 1
            else:
                ntimes -= 1
    return candidate


# 帖子超过了帖子总数目N的四分之一怎么快速查找，每次删除四个不同的ID -- 需要一个记录的容器。

if __name__ == '__main__':
    print(find2([1, 2, 1, 2, 1]))
    print(find3([1, 2, 1, 2, 1]))
