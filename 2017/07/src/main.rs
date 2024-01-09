use advent;
use std::collections::HashMap;
use regex::Regex;

fn main() {

  // Tests

  let test_data = vec!(
    "xhth (57)".to_string(),
    "ebii (61)".to_string(),
    "havc (66)".to_string(),
    "ktlj (57)".to_string(),
    "fwft (72) -> ktlj, cntj, xhth".to_string(),
    "qoyq (66)".to_string(),
    "padx (45) -> pbga, havc, qoyq".to_string(),
    "tknk (41) -> ugml, padx, fwft".to_string(),
    "jptl (61)".to_string(),
    "ugml (68) -> gyxo, ebii, jptl".to_string(),
    "gyxo (61)".to_string(),
    "cntj (57)".to_string(),
  );
  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  test.test_string("root program","tknk",&find_root(test_data));
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let input = advent::read_strings("input.txt");
  println!("Root program: {}", &find_root(input));
}

fn find_root(data: Vec<String>) -> String {
  let mut has_parent: HashMap<String, bool> = HashMap::new();
  let re = Regex::new(r"^([^ ]+) \(([0-9]+)\)(.*)$").unwrap();
  
  for line in &data {
    let Some(caps) = re.captures(&line) else {
      println!("line {} does not match!", line);
      return "".to_string();
    };
    if !has_parent.contains_key(&caps[1].to_string()) {
      has_parent.insert(caps[1].to_string(), false);
    }
    if &caps[3] != "" {
      let list_children = caps[3].strip_prefix(" -> ").unwrap();
      let children = list_children.split(", ");
      for child in children {
        has_parent.insert(child.to_string(), true);
      }
    }
  }

  for (prog, hp) in has_parent {
    if !hp {
      return prog;
    }
  }
  return "".to_string();
}
