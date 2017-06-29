from cassandra.cluster import Cluster

KEYSPACE = 'demodb'
USER_DEFINED_TYPE = 'addr'

cluster = Cluster(protocol_version=3)
session = cluster.connect()
session.set_keyspace(KEYSPACE)
session.execute("CREATE TYPE addr (street text, zipcode int)")
session.execute("CREATE TABLE user (id int primary, location frozen<addr>)")

class Addr(object):
    
    def __init__(self, street, zipcode):
        self.street = street
        self.zipcode = zipcode

cluster.register_user_type(KEYSPACE, 'addr', Addr)
session.execute("INSERT INTO user (id, location) VALUES (%s, %s)",
                (0, Addr("123 Main St.", 78123)))
results = session.execute("SELECT * FROM user")
row = results[0]
print row.id, row.location.street, row.location.zipcode
