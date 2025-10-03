package main

import "fmt"

// For strings S and T, we say "T divides S" if and only if S = T + ... + T  (T concatenated with itself 1 or more times)
//
// Return the largest string X such that X divides str1 and X divides str2.
//
//
//
// Example 1:
//
// Input: str1 = "ABCABC", str2 = "ABC"
// Output: "ABC"
// Example 2:
//
// Input: str1 = "ABABAB", str2 = "ABAB"
// Output: "AB"
// Example 3:
//
// Input: str1 = "LEET", str2 = "CODE"
// Output: ""
//
//
// Note:
//
// 1 <= str1.length <= 1000
// 1 <= str2.length <= 1000
// str1[i] and str2[i] are English uppercase letters.
func main() {
	fmt.Println(gcdOfStrings("ABABAB", "AB"))
}

func gcdOfStrings(str1 string, str2 string) string {
	minLength := 0
	if len(str1) < len(str2){
		str1, str2 = str2, str1
	}
	minLength = len(str2)
	for i := 0; i < minLength; i++ {
		if str1[i] != str2[i] {
			return ""
		}
	}
	if str1 == "" {
		return str2
	} else if str2 == "" {
		return str1
	}

	return gcdOfStrings(str1[minLength:len(str1)], str2)
}
