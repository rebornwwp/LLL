import multiprocessing, logging

logger = multiprocessing.log_to_stderr()
logger.setLevel(logging.INFO)
logger.warning('doomed')
m = multiprocessing.Manager()
del m
