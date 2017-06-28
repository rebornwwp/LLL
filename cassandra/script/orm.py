from cassandra.cqlengine import columns
from cassandra.cqlengine.models import Model


KEYSPACES = ['demodb']


class Person(Model):
    id = columns.UUID(primary_key=True)
    first_name = columns.Text()
    last_name = columns.Text()


class Comment(Model):
    phont_id = columns.UUID(primary_key=True)
    comment_id = columns.TimeUUID(primary_key=True, clustering_order='DESC')
    comment = columns.Text()


def sync_model_to_database():

    from cassandra.cqlengine.connection import setup
    from cassandra.cqlengine.management import sync_table, drop_table
    setup(["127.0.0.1"], 'demodb')
    sync_table(Person)
    sync_table(Comment)

if __name__ == '__main__':
    sync_model_to_database()
