# 洗牌算法

https://blog.csdn.net/qq_26399665/article/details/79831490

## 问题

假设有一个数组，包含n个元素。现在要重新排列这些元素，要求每个元素被放到任何一个位置的概率都相等(1/n)，并且
直接在数组上重排（inplace），不要生成新的数组。用O(n)时间,O(1)辅助空间。

## 1

``` python
import random

def shuffle(l):
    score_l = [(n, random.random()) for n in l]
    return list(map(lambda x: x[0], sorted(score_l, key=lambda x: x[1])))
```

## Fisher and Yates' shuffle


``` python
import random

def shuffle(l):
    for i in range(len(l) - 1, -1, -1):
        random_index = random.randint(0, i)
        l[i], l[random_index] = l[random_index], l[i]
```

可见任何元素出现在任何位置的概率都是相等的。即证明每个数字在某个位置的概率相等，都为1/n：
很显然他在第n个位置的概率是1/n，在倒数第二个位置概率是[(n-1)/n] * [1/(n-1)] = 1/n，在倒数第k个位置的概率是[(n-1)/n] * [(n-2)/(n-1)] *...* [(n-k+1)/(n-k+2)] *[1/(n-k+1)] = 1/n

``` python
# python源代码中实现
def shuffle(self, x, random=None):
    """Shuffle list x in place, and return None. Optional argument random is a 0-argument function returning a
    random float in [0.0, 1.0); if it is the default None, the
    standard random.random will be used.
    """

    if random is None:
        randbelow = self._randbelow
        for i in reversed(range(1, len(x))):
            # pick an element in x[:i+1] with which to exchange x[i]
            j = randbelow(i+1)
            x[i], x[j] = x[j], x[i]
    else:
        _int = int
        for i in reversed(range(1, len(x))):
            # pick an element in x[:i+1] with which to exchange x[i]
            j = _int(random() * (i+1))
            x[i], x[j] = x[j], x[i]
```

## 蓄水池抽样

从N个元素中随机等概率取出k个元素，N长度未知。它能够在o（n）时间内对n个数据进行等概率随机抽取。如果数据集合的量特别大或者还在增长（相当于未知数据集合总量），该算法依然可以等概率抽样.

``` C++
void Reservoir_Sampling(vector<int>& arr)
{
	int k;
	for (int i=M;i<arr.size();++i)
	{
		srand((unsigned)time(NULL));
		k=rand()%(i+1);
		if (k<M)
			swap(arr[k],arr[i]); 
	}
}
```