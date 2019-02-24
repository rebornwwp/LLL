# 调整数组顺序使奇数放在偶数前面
# 题目描述
# 输入一个整数数组，实现一个函数来调整
# 该数组中数字的顺序，使得所有的奇数位
# 于数组的前半部分，所有的偶数位于数组
# 的后半部分，并保证奇数和奇数，偶数和
# 偶数之间的相对位置不变。


class Solution:
    def reOrderArray(self, array):
        i = 0
        while i < len(array):
            if array[i] & 1 == 0:
                j = i
                while j < len(array) and array[j] & 1 == 0:
                    j = j + 1
                if j == len(array):
                    return array
                temp_i = i
                temp_j = j
                print(array)
                print(temp_i, temp_j)
                while temp_i < temp_j:
                    array[temp_j], array[temp_j - 1] = array[temp_j - 1], array[temp_j]
                    temp_j = temp_j - 1
                i = i + 1
            else:
                i = i + 1
        return array


if __name__ == "__main__":
    s = Solution()
    print(s.reOrderArray([1, 2, 3, 4, 5, 6, 7]))
    print(s.reOrderArray([2, 1]))
