use advent;
use std::collections::HashMap;

fn main() {
  // Tests

  let test_data = HashMap::from([
    ("123", 3),
    ("456", 3),
  ]);
  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  for (key, val) in test_data.iter() {
    let label = format!("sample: {}", key);
    test.test_i32(&label, *val, solve(key));
  }
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let input = advent::read_string("input.txt");
  let solution = solve(&input);
  println!("Solution: {}", solution);
}

fn solve(data: &str) -> i32 {
  return data.len() as i32;
}
