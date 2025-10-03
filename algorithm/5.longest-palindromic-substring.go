/*
 * @lc app=leetcode id=5 lang=golang
 *
 * [5] Longest Palindromic Substring
 */
package main

// import "fmt"

// func main() {
// 	fmt.Println(longestPalindrome("cbbd"))
// }

func longestPalindrome(s string) string {
	sNew := make([]byte, 0)
	sNew = append(sNew, '$')
	sNew = append(sNew, '#')
	for i := range s {
		sNew = append(sNew, []byte{s[i], '#'}...)
	}
	sNew = append(sNew, '!')
	p := make([]int, len(sNew))
	p[0] = 1
	id := 0
	mx := 0
	for i := 1; i < len(sNew)-1; i++ {
		if i < mx {
			p[i] = min(p[2*id-i], mx-i)
		} else {
			p[i] = 1
		}
		for sNew[i-p[i]] == sNew[i+p[i]] {
			p[i]++
		}
		if i+p[i] > mx {
			id = i
			mx = i + p[i]
		}
	}
	maxIndex := 0
	for i := range p {
		if p[i] > p[maxIndex] {
			maxIndex = i
		}
	}
	ans := make([]byte, 0)
	for i := maxIndex - p[maxIndex] + 1; i < maxIndex+p[maxIndex]; i++ {
		if sNew[i] != '#' && sNew[i] != '$' && sNew[i] != '!' {
			ans = append(ans, sNew[i])
		}
	}
	return string(ans)
}

func min(a, b int) int {
	if a > b {
		return b
	}
	return a
}
