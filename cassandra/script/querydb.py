from cassandra.cqlengine.connection import setup
from cassandra.cqlengine.named import NamedTable

setup(["127.0.0.1"], 'demodb')

user = NamedTable('demodb', 'users')
print user.objects()[0]
