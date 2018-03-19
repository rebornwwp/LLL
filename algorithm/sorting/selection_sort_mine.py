def selection_sort(L):
	"""
	this is a  selection sorting algorithm thay contains O(n^2) 
	number of comparisons and O(n) number of swaps. 
	------------------------
	fact ,that selection sort requires n-1 number of swaps at 
	most, makes it very efficient in situations, when write 
	operation is significantly more expensive, than read operation.
	time complexity: O(n^2)
	L: datatype list
	"""
	for i in range(len(L)):
		index_of_min = i
		j = i

		"""
		+--+--+--+--+--+--+
		|e1|e2|e3|e4|e5|e6|
		 ^ 	^
		 |  |
        index_of_min, j
        index_of_min：指向j之前的最小元素
        j：寻找最小元素时候,做搜索的量
		"""
		while j < len(L):
			if a[index_of_min] > a[j]:
				index_of_min = j
			j += 1

		"寻找到了我们需要的子序列的最小值，将最小值放入到子序列的第一个元素中"
		if i != index_of_min:
			L[i], L[index_of_min] = L[index_of_min], L[i]

if __name__ == "__main__":
	a = [5, 1, 12, -5, 16, 2, 12, 14]
	selection_sort(a)
	print(a)