#!/usr/bin/env python
# -*- coding:utf-8 -*-
from cassandra.cqlengine import columns
from cassandra.cqlengine.models import Model

class User(Model):
    __table_name__ = "user"

    user_id = columns.UUID(primary_key=True, default=uuid.uuid4)
    username = columns.text()
    email = columns.text()
    feedbacks = columns.List(columns.text)
    feedbacks_created_time = columns.List(columns.Datetime())
    tags = columns.Set(columns.text)



    

