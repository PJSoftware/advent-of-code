use advent;
use std::collections::HashMap;

fn main() {
  // Tests

  let test_data1 = HashMap::from([
    ("aa bb cc dd ee", true),
    ("aa bb cc dd aa", false),
    ("aa bb cc dd aaa", true),
  ]);

  let test_data2 = HashMap::from([
    ("abcde fghij", true),
    ("abcde xyz ecdab", false),
    ("a ab abc abd abf abj", true),
    ("iiii oiii ooii oooi oooo", true),
    ("oiii ioii iioi iiio", false),
    ]);

  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  for (pass_phrase, valid) in test_data1.iter() {
    let label = format!("pass phrase, policy 1: {}", pass_phrase);
    test.test_bool(&label, *valid, is_valid(&pass_phrase));
  }
  for (pass_phrase, valid) in test_data2.iter() {
    let label = format!("pass phrase, policy 2: {}", pass_phrase);
    test.test_bool(&label, *valid, is_valid_policy2(&pass_phrase));
  }
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let pass_phrases = advent::read_strings("04-input.txt");
  let mut total = 0;
  let mut valid1 = 0;
  let mut valid2 = 0;
  for pass_phrase in pass_phrases {
    total += 1;
    if is_valid(&pass_phrase) {
      valid1 += 1;
    }
    if is_valid_policy2(&pass_phrase) {
      valid2 += 1;
    }
  }
  println!("Solution: {}/{} valid", valid1, total);
  println!("Anagrams: {}/{} valid", valid2, total);
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

fn is_valid_policy2(pass_phrase: &str) -> bool {
  let mut words = HashMap::<String, bool>::new();
  for word in pass_phrase.split_whitespace() {
    let anagram = sorted_anagram(word);
    if words.contains_key(&anagram) {
      return false;
    }
    words.insert(anagram.to_string(), true);
  }
  return true;
}

fn sorted_anagram(word: &str) -> String {
  let old_word = String::from(word);
  let mut chars = old_word.chars().collect::<Vec<char>>();
  chars.sort_by(|a, b| b.cmp(a));
  return chars.iter().collect();
}
