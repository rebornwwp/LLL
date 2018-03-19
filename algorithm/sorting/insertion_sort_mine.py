def insertion_sort(a):
	"""
	this is a inserting sort of mine, it is not robust.
	a: data type(list)
	"""
	for i in range(1,len(a)):
		temp = a[i]
		j = i-1
		while j >= 0 and a[j] > temp:
				a[j+1] = a[j]
				j -= 1
		a[j+1] = temp

if __name__ == "__main__":
	a = [7, -5, 2, 16, 9]
	insertion_sort(a)
	print(a)

