#!/usr/bin/env python
# -*- coding:utf-8 -*-

import unittest

from bottle_db import BottleBucket, BottleDB


class BottleTest(unittest.TestCase):
    def setUp(self):
        self.bottle_bucket = BottleBucket('test_db')

    def testItem(self):
        self.bottle_bucket['a'] = 1
        self.bottle_bucket.save()
        self.assertEqual(self.bottle_bucket['a'], 1)
        self.assertEqual(len(self.bottle_bucket), 1)
        self.assertEqual(self.bottle_bucket['a'], 1)
        del self.bottle_bucket['a']
        self.assertEqual(self.bottle_bucket.cached_memory, dict())

    def testAttr(self):
        self.bottle_bucket.a = 1
        self.bottle_bucket.save()
        self.assertEqual(self.bottle_bucket.a, 1)
        del self.bottle_bucket.a
        self.assertEqual(self.bottle_bucket.db.keys(), [])

    def testOther(self):
        self.bottle_bucket['a'] = 1
        self.bottle_bucket['b'] = 2
        self.bottle_bucket.save()
        self.assertEqual(len(self.bottle_bucket), 2)
        self.assertTrue('a' in self.bottle_bucket)
        self.assertFalse('c' in self.bottle_bucket)
        self.assertEqual(self.bottle_bucket.keys(), ['a', 'b'])
        self.bottle_bucket.update({'c': 3, 'd': 4, 'e': 5, 'f': 6})
        for k, v in zip('abcdef', range(1, 7)):
            self.assertEqual(self.bottle_bucket[k], v)
        self.assertEqual(self.bottle_bucket.get('a'), 1)
        self.assertEqual(self.bottle_bucket.get('q', -100), -100)
        self.bottle_bucket.clear()
        self.assertEqual(self.bottle_bucket.cached_memory, {})


class BottleDBTest(unittest.TestCase):
    def setUp(self):
        self.db_manager = BottleDB()

    def testIterm(self):
        self.db_manager['db1'] = BottleBucket('db1')
        self.db_manager['db2'] = {'a': 1, 'b': 2}
        self.assertEqual(len(self.db_manager), 2)
        for db in self.db_manager:
            self.assertIsInstance(db, BottleBucket)
        del self.db_manager['db1']
        self.assertEqual(len(self.db_manager), 1)

    def testOther(self):
        self.db_manager['db1'] = BottleBucket('db1')
        self.db_manager['db2'] = {'a': 1, 'b': 2}
        self.db_manager.save()
        self.assertEqual(len(self.db_manager), 0)


if __name__ == "__main__":
    unittest.main()
