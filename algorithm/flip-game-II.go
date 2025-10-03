// You are playing the following Flip Game with your friend: Given a string that contains only these two characters: + and -, you and your friend take turns to flip two consecutive "++" into "--". The game ends when a person can no longer make a move and therefore the other person will be the winner.

// Write a function to determine if the starting player can guarantee a win.

// 样例
// Example1

// Input:  s = "++++"
// Output: true
// Explanation:
// The starting player can guarantee a win by flipping the middle "++" to become "+--+".
// Example2

// Input: s = "+++++"
// Output: false
// Explanation:
// The starting player can not win
// "+++--" --> "+----"
// "++--+" --> "----+"
// 挑战
// Derive your algorithm's runtime complexity.

/**
 * @param s: the given string
 * @return: if the starting player can guarantee a win
 */
package main

import "fmt"

func main() {
	fmt.Println(canWin("++"))
}
func canWin(s string) bool {
	var m map[string]bool
	m = make(map[string]bool)
	return memorizedSearch(s, m)
}
func memorizedSearch(s string, m map[string]bool) bool {
	if val, ok := m[s]; ok {
		return val
	}
	win := false
	for i := 0; i < len(s)-1; i++ {
		if s[i+1] == '+' && s[i] == '+' {
			rst := memorizedSearch(s[0:i]+"--"+s[i+2:len(s)], m)
			if !rst {
				win = true
				break
			}
		}
	}
	m[s] = win
	return win
}
