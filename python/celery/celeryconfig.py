BROKER_URL = 'redis://localhost'
CELERY_RESULT_BACKEND = 'redis://localhost'

# CELERY_TASK_SERIALIZER = 'json'
# CELERY_RESULT_SERIALIZER = 'json'
# CELERY_ACCEPT_CONTENT = ['json']
# CELERY_TIMEZONE = 'Europe/Oslo'
# CELERY_ENABLE_UTC = True

# # 低优先级
# CELERY_ROUTES = {
#     'tasks.add': 'low-priority',
# }

# # 每分钟处理10个任务
# CELERY_ANNOTATIONS = {
#     'tasks.add': {'rate_limit': '10/m'}
# }
