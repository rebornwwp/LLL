class Solution:
    def intToRoman(self, num):
        """
        :type num: int
        :rtype: str
        """
        roman = [["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"],
                 ["", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"],
                 ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"],
                 ["", "M", "MM", "MMM"]]
        res = []
        res.append(roman[3][num // 1000 % 10])
        res.append(roman[2][num // 100 % 10])
        res.append(roman[1][num // 10 % 10])
        res.append(roman[0][num % 10])
        return "".join(res)
