use advent;
use std::collections::HashMap;

fn main() {
  // Tests

  let test1_data = HashMap::from([
    ("1122", 3),
    ("1111", 4),
    ("1234", 0),
    ("91212129", 9),
  ]);

  let test2_data = HashMap::from([
    ("1212", 6),
    ("1221", 0),
    ("123425", 4),
    ("123123", 12),
    ("12131415", 4),
  ]);

  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  for (key, val) in test1_data.iter() {
    let label = format!("captcha 1 test: {}", key);
    test.test_i32(&label, *val, captcha1(key));
  }
  for (key, val) in test2_data.iter() {
    let label = format!("captcha 2 test: {}", key);
    test.test_i32(&label, *val, captcha2(key));
  }
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let mut data = advent::Data::new();
  data.read_string("01-input.txt");
  let solution1 = captcha1(&data.string());
  let solution2 = captcha2(&data.string());
  println!("Solution 1: {}", solution1);
  println!("Solution 2: {}", solution2);
}

fn captcha1(data: &str) -> i32 {
  let mut captcha = 0 as i32;
  let mut comp = data.chars().last().unwrap();
  for ch in data.chars() {
    if comp == ch {
      captcha += ch.to_digit(10).unwrap_or(0) as i32;
    }
    comp = ch
  }
  return captcha;
}

fn captcha2(data: &str) -> i32 {
  let mut captcha = 0 as i32;
  let offset = data.len()/2;
  for (i, ch) in data.chars().enumerate() {
    let mut j = i + offset;
    if j >= data.len() {
      j -= data.len();
    }
    if ch == data.chars().nth(j).expect("no character found") {
      captcha += ch.to_digit(10).unwrap_or(0) as i32;
    }
  }
  return captcha;
}
