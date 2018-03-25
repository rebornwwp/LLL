import unittest

from orderedSet import OrderedSet


class OrderedDictTestCase(unittest.TestCase):
    def setUp(self):
        self.ordSet = OrderedSet(list('abc'))

    def tearDown(self):
        self.ordSet = None

    def test_init(self):
        self.assertEqual(list(self.ordSet), list('abc'))

    def test_contains(self):
        self.assertTrue('a' in self.ordSet)
        self.assertFalse('d' in self.ordSet)

    def test_add(self):
        self.ordSet.add('d')
        self.assertTrue('d' in self.ordSet)

    def test_remove(self):
        self.ordSet.discard('a')
        self.assertFalse('a' in self.ordSet)

    def test_bool(self):
        self.assertTrue(bool(self.ordSet))

    def test_len(self):
        self.assertEqual(len(self.ordSet), 3)


if __name__ == '__main__':
    unittest.main()
