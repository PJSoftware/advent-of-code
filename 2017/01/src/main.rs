use advent;
use std::collections::HashMap;

fn main() {
  // Tests

  let test_data = HashMap::from([
    ("1122", 3),
    ("1111", 4),
    ("1234", 0),
    ("91212129", 9),
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

  let mut data = advent::Data::new();
  data.read_string("01-input.txt");
  let solution = solve(&data.string());
  println!("Solution: {}", solution);
}

fn solve(data: &str) -> i32 {
  return data.len() as i32;
}
