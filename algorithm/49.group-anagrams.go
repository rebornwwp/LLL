/*
 * @lc app=leetcode id=49 lang=golang
 *
 * [49] Group Anagrams
 */

package main

import (
	"sort"
	"strings"
)

// func main() {
// 	fmt.Println(groupAnagrams([]string{"eat", "tea", "tan", "ate", "nat", "bat"}))
// }

func groupAnagrams(strs []string) [][]string {
	m := make(map[string][]string)
	for i := range strs {
		ss := strings.Split(strs[i], "")
		sort.Strings(ss)
		s := strings.Join(ss, "")
		if _, ok := m[s]; !ok {
			m[s] = make([]string, 0)
		}
		m[s] = append(m[s], strs[i])
	}
	ans := make([][]string, 0)
	for _, v := range m {
		ans = append(ans, v)
	}
	return ans
}
