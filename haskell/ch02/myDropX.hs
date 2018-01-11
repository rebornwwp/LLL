myDropx n xs = if n <= 0 || null xs then xs else myDropx (n - 1) (tail xs)
