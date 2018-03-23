import unittest


class FixturesTest(unittest.TestCase):

    def setUp(self):
        print 'In setup()'
        self.fixture = range(1, 10)

    def tearDown(self):
        print 'in tearDown()'
        del self.fixture

    def test(self):
        print 'in test'
        self.assertEqual(self.fixture, range(1, 10))


if __name__ == '__main__':
    unittest.main()
