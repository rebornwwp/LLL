// You are playing the following Flip Game with your friend: Given a string that contains only these two characters: + and -, you and your friend take turns to flip two consecutive "++" into "--". The game ends when a person can no longer make a move and therefore the other person will be the winner.

// Write a function to compute all possible states of the string after one valid move.

// 样例
// Example1

// Input:  s = "++++"
// Output:
// [
//   "--++",
//   "+--+",
//   "++--"
// ]
// Example2

// Input: s = "---+++-+++-+"
// Output:
// [
// 	"---+++-+---+",
// 	"---+++---+-+",
// 	"---+---+++-+",
// 	"-----+-+++-+"
// ]

/**
 * @param s: the given string
 * @return: all the possible states of the string after one valid move
 */
package main

import "fmt"

func main() {
	fmt.Println(generatePossibleNextMoves(""))
}

func generatePossibleNextMoves(s string) []string {
	if len(s) == 0 {
		return []string{}
	}
	var ans []string
	i := len(s) - 1
	for i > 0 {
		if s[i] == s[i-1] && s[i] == '+' {
			ans = append(ans, s[0:i-1]+"--"+s[i+1:len(s)])
		}
		i -= 1
	}
	return ans
}
