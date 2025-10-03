// There are n coins in a line. Two players take turns to take one or two coins from right side until there are no more coins left. The player who take the last coin wins.

// Could you please decide the first player will win or lose?

// If the first player wins, return true, otherwise return false.

// 样例
// Example 1:

// Input: 1
// Output: true
// Example 2:

// Input: 4
// Output: true
// Explanation:
// The first player takes 1 coin at first. Then there are 3 coins left.
// Whether the second player takes 1 coin or two, then the first player can take all coin(s) left.
// 挑战
// O(n) time and O(1) memory

/**
 * @param n: An integer
 * @return: A boolean which equals to true if the first player will win
 */
func firstWillWin(n int) bool {
	if n == 0 {
		return false
	}
	dp := make([]bool, n+1)
	dp[0] = false
	dp[1] = true
	for i := 2; i < n+1; i++ {
		dp[i] = (!dp[i-1]) || (!dp[i-2])
	}
	return dp[n]
}
