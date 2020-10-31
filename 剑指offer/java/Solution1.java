// 题目描述
// 在一个二维数组中（每个一维数组的长度相同），每一行都按照从左到右递增的顺序排序，
// 每一列都按照从上到下递增的顺序排序。请完成一个函数，输入这样的一个二维数组和一个整数，判断数组中是否含有该整数。
// 示例1
// 输入
// 7,[[1,2,8,9],[2,4,9,12],[4,7,10,13],[6,8,11,15]]
// true

class Solution1 {
    public static boolean Findk(int target, int[][] array) {
        if (array.length == 0) {
            return false;
        }
        
        int i = 0;
        int j = array[0].length - 1;
        int width = array[0].length;
        int height = array.length;

        while (i < height && j >= 0) {
            if (array[i][j] == target) {
                return true;
            }
            if (array[i][j] > target) {
                j--;
            } else if (array[i][j] < target) {
                i++;
            }
        }
        return false;
    }
}
