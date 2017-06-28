from cassandra import ReadTimeout

from connect_cassandra import init_cassandra


KEYSPACE = 'demodb'
TABLE_NAME = 'users'


def test_asyn():
    session = init_cassandra()
    session.set_keyspace(KEYSPACE)
    query = 'SELECT * FROM {}'.format(TABLE_NAME)
    future = session.execute_async(query)
    try:
        rows = future.result()
        user = rows[0]
        print user.user_name, user.birth_year
    except ReadTimeout:
        log.exeception("Query timed out")

if __name__ == '__main__':
    test_asyn()
