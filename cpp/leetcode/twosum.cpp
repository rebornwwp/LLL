#include <iostream>
#include <map>
#include <vector>

using namespace std;

class Solution {
 public:
  vector<int> twoSum(vector<int> &nums, int target) {
    map<int, int> m{};
    vector<int> result{};
    for (int i = 0; i < nums.size(); i++) {
      if (m.find(target - nums[i]) != m.end()) {
        result.push_back(m.find(target - nums[i])->second);
        result.push_back(i);
        break;
      }
      m.insert(pair<int, int>(nums[i], i));
    }
    return result;
  }
};