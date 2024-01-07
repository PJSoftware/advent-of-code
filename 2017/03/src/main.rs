use advent;
use std::collections::HashMap;

fn main() {
  // Tests

  let test_data = HashMap::from([
    ("1", 0),
    ("4", 1),
    ("9", 2),
    ("16", 3),
    ("25", 4),
    ("12", 3),
    ("23", 2),
    ("1024", 31),
  ]);
  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  for (key, val) in test_data.iter() {
    let label = format!("sample: {}", key);
    let test_int = key.parse::<i32>().unwrap();
    test.test_i32(&label, *val, manhattan_distance(test_int));
  }
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let input = advent::read_i32("03-input.txt");
  let solution = manhattan_distance(input);
  println!("Manhattan Distance: {}", solution);
}

fn manhattan_distance(mut data: i32) -> i32 {
  let mut d1 = 1;
  let mut d2 = 1;

  let mut x = 0;
  let mut y = 0;

  data -= 1;

  while data > 0 {

    // Right
    if data < d1 {
      d1 = data;
    }
    x += d1;
    data -= d1;
    if data == 0 {
      break;
    }
    d1 += 1;

    // Up
    if data < d2 {
      d2 = data;
    }
    y += d2;
    data -= d2;
    if data == 0 {
      break;
    }
    d2 += 1;

    // Left
    if data < d1 {
      d1 = data;
    }
    x -= d1;
    data -= d1;
    if data == 0 {
      break;
    }
    d1 += 1;

    // Down
    if data < d2 {
      d2 = data;
    }
    y -= d2;
    data -= d2;
    if data == 0 {
      break;
    }
    d2 += 1;

  }
  return x.abs() + y.abs();
}
