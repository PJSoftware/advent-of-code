use advent;
use std::collections::HashMap;

fn main() {
  // Tests

  let test_data = HashMap::from([
    ("aa bb cc dd ee", true),
    ("aa bb cc dd aa", false),
    ("aa bb cc dd aaa", true),
  ]);
  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  for (pass_phrase, valid) in test_data.iter() {
    let label = format!("pass phrase: {}", pass_phrase);
    test.test_bool(&label, *valid, is_valid(&pass_phrase));
  }
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let pass_phrases = advent::read_strings("04-input.txt");
  let mut total = 0;
  let mut valid = 0;
  for pass_phrase in pass_phrases {
    total += 1;
    if is_valid(&pass_phrase) {
      valid += 1;
    }
  }
  println!("Solution: {}/{} valid", valid, total);
}

fn is_valid(pass_phrase: &str) -> bool {
  let mut words = HashMap::<String, bool>::new();
  for word in pass_phrase.split_whitespace() {
    if words.contains_key(word) {
      return false;
    }
    words.insert(word.to_string(), true);
  }
  return true;
}
