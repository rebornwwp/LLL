import uuid
import faker

from cassandra.cqlengine.query import BatchQuery
from cassandra.cqlengine.connection import setup

from orm import Person


setup(['127.0.0.1'], 'demodb')
fake = faker.Factory().create()
with BatchQuery() as b:
    person1 = Person.batch(b).create(id=uuid.uuid4(), \
                                     first_name=fake.first_name(), \
                                     last_name=fake.last_name())
    person2 = Person.batch(b).create(id=uuid.uuid4(), \
                                     first_name=fake.first_name(), \
                                     last_name=fake.last_name())
    person3 = Person.batch(b).create(id=uuid.uuid4(), \
                                     first_name=fake.first_name(), \
                                     last_name=fake.last_name())
    

