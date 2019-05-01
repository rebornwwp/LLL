/*
 * @lc app=leetcode id=6 lang=golang
 *
 * [6] ZigZag Conversion
 */
package main

// func main() {
// 	fmt.Println(convert("A", 1))
// }

func convert(s string, numRows int) string {
	if numRows <= 1 {
		return s
	}
	mod := numRows*2 - 2
	ans := make([][]byte, numRows)
	for i := range ans {
		ans[i] = make([]byte, 0)
	}
	for i := 0; i < len(s); i++ {
		tmp := i % mod
		if tmp < numRows {
			ans[tmp] = append(ans[tmp], s[i])
		} else {
			ans[mod-tmp] = append(ans[mod-tmp], s[i])
		}
	}
	var x string
	for i := range ans {
		x += string(ans[i])
	}
	return x
}
