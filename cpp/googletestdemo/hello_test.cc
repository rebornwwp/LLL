#include <gtest/gtest.h>

#include "counter.h"
#include "queue.h"

int Factorial(int n) {
  if (n < 0) {
    return 1;
  }
  if ((n == 0) || (n == 1)) {
    return 1;
  }

  return Factorial(n - 1) + Factorial(n - 2);
}

// Demonstrate some basic assertions.
// helloTest stand for test suite name
// basicAssertions for test name
TEST(HelloTest, BasicAssertions) {
  // Expect two strings not to be equal.
  EXPECT_STRNE("hello", "world");
  // Expect equality.
  EXPECT_EQ(7 * 6, 42);
}

TEST(FactorialTest, Negative) {
  EXPECT_EQ(1, Factorial(-5));
  EXPECT_EQ(1, Factorial(-1));
  EXPECT_GT(Factorial(-1), 0);
}

TEST(FactorialTest, HandlesZeroInput) { EXPECT_EQ(Factorial(0), 1); }

TEST(FactorialTest, HandlesPositiveInput) {
  EXPECT_EQ(Factorial(1), 1);
  EXPECT_EQ(Factorial(2), 2);
  EXPECT_EQ(Factorial(3), 3);
}

// The fixture for testing class Foo.
class FooTest : public ::testing::Test {
 protected:
  // You can remove any or all of the following functions if their bodies would
  // be empty.

  FooTest() {
    // You can do set-up work for each test here.
  }

  ~FooTest() override {
    // You can do clean-up work that doesn't throw exceptions here.
  }

  // If the constructor and destructor are not enough for setting up
  // and cleaning up each test, you can define the following methods:

  void SetUp() override {
    // Code here will be called immediately after the constructor (right
    // before each test).
    std::cout << "set up\n";
  }

  void TearDown() override {
    // Code here will be called immediately after each test (right
    // before the destructor).
    std::cout << "tear down\n";
  }

  // Class members declared here can be used by all tests in the test suite
  // for Foo.
  class Foo {
   public:
    int Bar(std::string input_file, std::string output_file) { return 0; }
  };
};

// Tests that the Foo::Bar() method does Abc.
TEST_F(FooTest, MethodBarDoesAbc) {
  const std::string input_filepath = "this/package/testdata/myinputfile.dat";
  const std::string output_filepath = "this/package/testdata/myoutputfile.dat";
  Foo f{};
  EXPECT_EQ(f.Bar(input_filepath, output_filepath), 0);
}

// Tests that Foo does Xyz.
TEST_F(FooTest, DoesXyz) {
  // Exercises the Xyz feature of Foo.
}

class QueueTest : public testing::Test {
 public:
  Queue<int> q0_;
  Queue<int> q1_;
  Queue<int> q2_;

 protected:
  void SetUp() override {
    q1_.Enqueue(1);
    q2_.Enqueue(2);
    q2_.Enqueue(3);
  }

  static int Double(int n) { return 2 * n; }

  void MapTester(const Queue<int> *q) {
    // Creates a new queue, where each element is twice as big as the
    // corresponding one in q.
    const Queue<int> *const new_q = q->Map(Double);

    // Verifies that the new queue has the same size as q.
    ASSERT_EQ(q->Size(), new_q->Size());

    // Verifies the relationship between the elements of the two queues.
    for (const QueueNode<int> *n1 = q->Head(), *n2 = new_q->Head();
         n1 != nullptr; n1 = n1->next(), n2 = n2->next()) {
      EXPECT_EQ(2 * n1->element(), n2->element());
    }

    delete new_q;
  }
};

TEST_F(QueueTest, DefaultConstructor) {
  // You can access data in the test fixture here.
  EXPECT_EQ(0u, q0_.Size());
}

// Tests Dequeue().
TEST_F(QueueTest, Dequeue) {
  int *n = q0_.Dequeue();
  EXPECT_TRUE(n == nullptr);

  n = q1_.Dequeue();
  ASSERT_TRUE(n != nullptr);
  EXPECT_EQ(1, *n);
  EXPECT_EQ(0u, q1_.Size());
  delete n;

  n = q2_.Dequeue();
  ASSERT_TRUE(n != nullptr);
  EXPECT_EQ(2, *n);
  EXPECT_EQ(1u, q2_.Size());
  delete n;
}

// Tests the Queue::Map() function.
TEST_F(QueueTest, Map) {
  MapTester(&q0_);
  MapTester(&q1_);
  MapTester(&q2_);
}

TEST(Counter, Increment) {
  Counter c;
  EXPECT_EQ(0, c.Decrement());

  EXPECT_EQ(0, c.Increment());
  EXPECT_EQ(1, c.Increment());
  EXPECT_EQ(2, c.Increment());
  EXPECT_EQ(3, c.Increment());
  EXPECT_EQ(4, c.Decrement())
      << "hello world";  // streaming custom failure message
}

TEST(Counter, Assertions) {
  ADD_FAILURE() << "add failure, continue running";
  SUCCEED() << "custom Explicit success output";
  FAIL() << "custom Explicit fail output";
}

TEST(SkipTest, DoesSkip) {
  GTEST_SKIP() << "skipping single test";
  EXPECT_EQ(0, 1);
}

class SkipFixture : public ::testing::Test {
 protected:
  void SetUp() override {
    GTEST_SKIP() << "Skipping all tests for this fixture";
  }
};

// Tests for SkipFixture won't be executed.
TEST_F(SkipFixture, SkipsOneTest) {
  EXPECT_EQ(5, 7);  // Won't fail
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
