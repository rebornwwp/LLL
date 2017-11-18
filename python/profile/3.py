import pstats
p = pstats.Stats('restats')
p.strip_dirs().sort_stats(-1).print_stats()
