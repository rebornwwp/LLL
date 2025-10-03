# Say you have an array for which the ith element is the price of a given stock on day i.

# If you were only permitted to complete at most one transaction (i.e., buy one and sell one share of the stock), design an algorithm to find the maximum profit.

# Note that you cannot sell a stock before you buy one.

# Example 1:

# Input: [7,1,5,3,6,4]
# Output: 5
# Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.
#              Not 7-1 = 6, as selling price needs to be larger than buying price.
# Example 2:

# Input: [7,6,4,3,1]
# Output: 0
# Explanation: In this case, no transaction is done, i.e. max profit = 0.


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

    def maxProfit1(self, prices):
        length = len(prices)

        if length < 1:
            return 0

        # i之前的最低价格
        L = [0] * length
        # i之前的最高收益
        P = [0] * length
        L[0] = prices[0]
        for i in range(1, length):
            P[i] = max(P[i - 1], prices[i] - L[i - 1])
            L[i] = min(prices[i], L[i - 1])

        return P[length - 1]

    def maxProfit2(self, prices):
        length = len(prices)

        if length < 1:
            return 0

        # i之前的最低价格
        L = prices[0]
        # i之前的最高收益
        P = [0] * length
        L[0] = prices[0]
        for i in range(1, length):
            P[i] = max(P[i - 1], prices[i] - L)
            L = min(prices[i], L)

        return P[length - 1]
