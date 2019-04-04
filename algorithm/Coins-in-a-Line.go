// There are n coins in a line. Two players take turns to take one or two coins from right side until there are no more coins left. The player who take the last coin wins.

// Could you please decide the first player will win or lose?

// If the first player wins, return true, otherwise return false.

// Example
// Example 1:

// Input: 1
// Output: true
// Example 2:

// Input: 4
// Output: true
// Explanation:
// The first player takes 1 coin at first. Then there are 3 coins left.
// Whether the second player takes 1 coin or two, then the first player can take all coin(s) left.
// Challenge
// O(n) time and O(1) memory

/**
 * @param n: An integer
 * @return: A boolean which equals to true if the first player will win
 */
package main

import "fmt"

func firstWillWin(n int) bool {
	dp := make([]int, n+1)
	if n <= 2 {
		return true
	}
	user := -1
	dp[1] = 1
	dp[2] = 1
	for {
		user = (user + 1) % 2
		for i := 1; i <= 2; i++ {
			for j := range dp {
				if dp[j] > 0 {
					dp[j+i] = 1
					fmt.Println(dp)
					if i+j == n {
						fmt.Println(n)
						fmt.Println(user)
						return user == 0
					}
				}
			}
		}

	}
	// return false
}

func main() {
	fmt.Println(firstWillWin(3))
}
