import collections

Card = collections.namedtuple('Card', ['rank', 'suit'])


class FrenchDeck:
    ranks = [str(n) for n in range(2, 11)] + list('JQKA')
    suits = 'spades diamonds clubs hearts'.split()

    def __init__(self):
        self._cards = [Card(rank, suit)
                       for rank in self.ranks
                       for suit in self.suits]

    def __len__(self):
        return len(self._cards)

    def __getitem__(self, position):
        return self._cards[position]


beer_card = Card('7', 'diamonds')
print(beer_card)

deck = FrenchDeck()

print(len(deck))
print(deck[1])
print(deck[:10])

# according to PEP234
# 在用 for..in.. 迭代对象时，如果对象没有实现 __iter__ __next__ 迭代器协议，Python的解释器就会去寻找__getitem__ 来迭代对象，如果连__getitem__ 都没有定义，这解释器就会报对象不是迭代器的错误：
for d in deck:
    print(d)

# __contains__ 方法没有实现，python解析器将去看此类型是否可以迭代的，可迭代的，将会去做一次迭代搜索
print(Card('Q', 'hearts') in deck)
