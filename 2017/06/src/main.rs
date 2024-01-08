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
    test.test_string(&label, *val, &next_cycle(key));
  }
  test.test_i32("cycles before repeat", 5, count_cycles("0 2 7 0"));
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let input = advent::read_string("input.txt");
  let solution = count_cycles(&input);
  println!("Solution: {}", solution);
}

fn next_cycle(data: &str) -> String {
  let mut vec = string_to_vec(data);
  let mut index: usize = 0;
  let mut largest: i32 = vec[index];
  for i in 1..vec.len() {
    if vec[i] > largest {
      largest = vec[i];
      index = i;
    }
  }
  vec[index] = 0;
  while largest > 0 {
    index += 1;
    if index == vec.len() {
      index = 0;
    }
    vec[index as usize] += 1;
    largest -= 1;
  }
  return vec_to_string(vec);
}

fn count_cycles(data: &str) -> i32 {
  let mut seen: HashMap<String, bool> = Default::default();
  let mut count = 0;
  let mut next = String::from(data);
  loop {
    if seen.contains_key(&next) {
      return count;
    }
    seen.insert(next.clone(), true);
    next = next_cycle(&next);
    count += 1;
  }
}

fn string_to_vec(data: &str) -> Vec<i32> {
  let mut vec = Vec::new();
  for line in data.split_whitespace() {
    let value = line.parse::<i32>().unwrap();
    vec.push(value);
  }
  vec
}

fn vec_to_string(vec: Vec<i32>) -> String {
  let mut rv: String = vec[0].to_string();
  for i in 1..vec.len() {
    rv.push_str(" ");
    rv.push_str(&vec[i].to_string());
  }
  rv
}