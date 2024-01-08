use advent;
use std::collections::HashMap;

fn main() {
  // Tests

  let test_data_cycle = HashMap::from([
    ("0 2 7 0", "2 4 1 2"),
    ("2 4 1 2", "3 1 2 3"),
    ("3 1 2 3", "0 2 3 4"),
    ("0 2 3 4", "1 3 4 1"),
    ("1 3 4 1", "2 4 1 2"),
  ]);
  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  for (key, val) in test_data_cycle.iter() {
    let label = format!("input: {}", key);
    test.test_string(&label, *val, next_cycle(key));
  }
  test.test_i32("cycles before repeat", 5, count_cycles("0 2 7 0"));
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let input = advent::read_string("input.txt");
  let solution = count_cycles(&input);
  println!("Solution: {}", solution);
}

fn next_cycle(data: &str) -> &str {
  return data;
}

fn count_cycles(data: &str) -> i32 {
  return data.len() as i32;
}
