from cassandra.cluster import Cluster


KEYSPACE = 'demodb'
TABLE_NAME = 'users'


def init_cassandra():
    cluster = Cluster(port=9042)
    session = cluster.connect()
    return session


def main():
    session = init_cassandra()
    session.set_keyspace(KEYSPACE)
    rows = session.execute(
        'SELECT * FROM {}'.format(TABLE_NAME))
    for row in rows:
        print row.user_name, row.gender

if __name__ == '__main__':
    main()
