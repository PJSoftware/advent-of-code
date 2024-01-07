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
  let test_data2 = HashMap::from([
    ("1", 2),
    ("4", 5),
    ("9", 10),
    ("16", 23),
    ("25", 26),
    ("12", 23),
    ("23", 25),
  ]);

  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  for (key, val) in test_data.iter() {
    let label = format!("#1 sample: {}", key);
    let test_int = key.parse::<i32>().unwrap();
    test.test_i32(&label, *val, manhattan_distance(test_int));
  }
  for (key, val) in test_data2.iter() {
    let label = format!("#2 sample: {}", key);
    let test_int = key.parse::<i32>().unwrap();
    test.test_i32(&label, *val, stress_test(test_int));
  }
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let input = advent::read_i32("03-input.txt");
  let solution = manhattan_distance(input);
  let solution2 = stress_test(input);
  println!("Manhattan Distance: {}", solution);
  println!("Stress Test: {}", solution2);
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

fn stress_test(data: i32) -> i32 {
  let mut memory = HashMap::from([
    (memory_key(0,0), 1),
  ]);

  let mut d1 = 1;
  let mut d2 = 1;

  let mut x = 0;
  let mut y = 0;

  let mut value;

  loop {

    // Right
    for _n in 1..d1+1 {
      x += 1;
      value = determine_value(x, y, &memory);
      memory.insert(memory_key(x,y), value);
      if value > data {
        return value;
      }      
    }
    d1 += 1;

    // Up
    for _n in 1..d2+1 {
      y += 1;
      value = determine_value(x, y, &memory);
      memory.insert(memory_key(x,y), value);
      if value > data {
        return value;
      }      
    }
    d2 += 1;

    // Left
    for _n in 1..d1+1 {
      x -= 1;
      value = determine_value(x, y, &memory);
      memory.insert(memory_key(x,y), value);
      if value > data {
        return value;
      }      
    }
    d1 += 1;

    // Down
    for _n in 1..d2+1 {
      y -= 1;
      value = determine_value(x, y, &memory);
      memory.insert(memory_key(x,y), value);
      if value > data {
        return value;
      }      
    }
    d2 += 1;

  }
}

fn memory_key(x: i32, y:i32) -> String {
  let key = format!("({}:{})", x, y);
  key
}

fn determine_value(x: i32, y:i32, memory: &HashMap<String, i32>) -> i32 {
  let mut total: i32;
  total = 0;

  for ix in -1..1+1 { // for ix in -1..1 only loops through -1, 0 !!!!!
    for iy in -1..1+1 {
      let key = memory_key(x+ix, y+iy);
      if memory.contains_key(&key) {
        let val = memory.get(&key).unwrap();
        total += val;
      }
    }
  }
  total
}