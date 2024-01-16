use advent;
use day07::tower::Tower;

use std::collections::HashMap;
use regex::Regex;

fn main() {

  // Tests

  let test_data = vec!(
    "xhth (57)",
    "ebii (61)",
    "havc (66)",
    "ktlj (57)",
    "fwft (72) -> ktlj, cntj, xhth",
    "qoyq (66)",
    "padx (45) -> pbga, havc, qoyq",
    "tknk (41) -> ugml, padx, fwft",
    "jptl (61)",
    "ugml (68) -> gyxo, ebii, jptl",
    "gyxo (61)",
    "cntj (57)",
  );
  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  let mut test_tower = Tower::new();
  for line in test_data {
    test_tower.import(line.to_string());
  }

  // test.test_string("root program","tknk",&find_root(test_data));
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let input = advent::read_strings("input.txt");
  let mut tower = Tower::new();
  for line in input {
    tower.import(line);
  }
  // println!("Root program: {}", &find_root(input));
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
