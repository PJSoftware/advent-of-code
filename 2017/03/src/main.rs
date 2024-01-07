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

fn manhattan_distance(data: i32) -> i32 {
  let root = f32::sqrt(data as f32) as i32;
  let mut extra = data - root * root;
  
  let mut x: i32;
  let mut y: i32;
  if root%2 == 0 {
    y = root/2 - 1;
    x = root/2; // actually "-root/2" but let's just use absolutes to simplify
  } else {
    y = (root-1)/2;
    x = y;
  }
  
  println!("For {}, we are {} beyond {}^2", data, extra, root);
  if extra > 0 {
    x += 1;
    extra -= 1;
  }

  if extra <= root {
    y -= extra;
    println!("<= root Coord: ({},{})", x, y)
  } else {
    extra -= root;
    x -= extra;
    println!("> root Coord: ({},{})", x, y)
  }
  
  return x.abs() + y.abs();
}
