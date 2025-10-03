package main

// 描述
// 中文
// English
// 给出不同面额的硬币以及一个总金额. 写一个方法来计算给出的总金额可以换取的最少的硬币数量. 如果已有硬币的任意组合均无法与总金额面额相等, 那么返回 -1.
//
// 你可以假设每种硬币均有无数个
//
// 您在真实的面试中是否遇到过这个题？
// 样例
// 样例1
//
// 输入：
// [1, 2, 5]
// 11
// 输出： 3
// 解释： 11 = 5 + 5 + 1
// 样例2
//
// 输入：
// [2]
// 3
// 输出： -1

import "fmt"

func main() {
	coins := []int{1, 2, 5}
	amount := 11
	fmt.Println(coinChange(coins, amount))
}

/**
 * @param coins: a list of integer
 * @param amount: a total amount of money amount
 * @return: the fewest number of coins that you need to make up
 */
func coinChange(coins []int, amount int) int {
	maxInt := 1 << 32
	dp := make([]int, amount+1)
	for i := 1; i <= amount; i++ {
		dp[i] = maxInt
	}
	for i := 0; i <= amount; i++ {
		for j := 0; j < len(coins); j++ {
			if i-coins[j] >= 0 {
				dp[i] = min(dp[i], dp[i-coins[j]]+1)
			}
		}
	}
	ans := dp[amount]
	if ans == maxInt {
		ans = -1
	}
	return ans
}

func min(a, b int) int {
	if a > b {
		return b
	}
	return a
}
