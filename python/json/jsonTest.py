#!/usr/bin/env python
# encoding: utf-8
"""
JSON (JaveScript Object Notation)
"""
import json

data = {"name": "wwp", "user_name": "rebornwwp"}

jsonData = json.dumps(data)

print(jsonData)

jsonData = json.dumps(data, sort_keys=True, indent=4)

print(jsonData)
