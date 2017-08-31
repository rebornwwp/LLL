class Solution(object):
    def maxProfit(self, prices):
        """
        :type prices: List[int]
        :rtype: int
        """
        profit = 0
        min_price = 100000
        for price in prices:
            if min_price > price:
                min_price = price
            elif price - min_price > profit:
                profit = price - min_price
        return profit
