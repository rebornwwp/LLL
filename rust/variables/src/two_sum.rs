use std::collections::HashMap;

impl Solution {
    pub fn two_sum(nums: Vec<i32>, target: i32) -> Vec<i32> {
        let mut d = HashMap::new();

        for (i, &num) in nums.iter().enumerate() {
            let v = target - num;
            if let Some(t_i) = d.get(&v) {
                return vec![*t_i as i32, i as i32];
            }
            d.insert(num, i);
        }
        vec![]
    }
}
