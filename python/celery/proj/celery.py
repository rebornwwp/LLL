from celery import Celery

app = Celery('proj',
             backend='redis://localhost',
             broker='redis://localhost',
             include=['proj.tasks'])

# optional configuration, see the application user guide.
app.conf.update(
    result_expires=3600,
)

if __name__ == "__main__":
    app.start()
