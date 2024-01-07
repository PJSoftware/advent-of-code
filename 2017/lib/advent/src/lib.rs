use std::fs;

// Test code

pub struct Test {
  run: i32,
  failed: i32,
}

impl Test {
  pub fn new() -> Test {
    Test {
      run: 0,
      failed: 0,
    }
  }

  pub fn test_i32(&mut self, label: &str, exp: i32, got: i32) {
    self.run += 1;
    if got == exp {
      println!("OK -- '{}' => {} / passed", label, got);
    } else {
      println!("FAIL -- '{}' / failed;\n  - exp '{}';\n  - got '{}'", label, exp, got);
      self.failed += 1;
    }
  }

  pub fn bail_on_fail(&mut self) {
    if self.failed > 0 {
      println!("\nSample Data Tests: {}/{} failed\n", self.failed, self.run);
      std::process::exit(1);
    }
    println!("");
  }
  
}

// Data code

pub fn read_string(filename: &str) -> String {
  let data = fs::read_to_string(filename).expect("Unable to read file");
  return data;
}

pub fn read_i32(filename: &str) -> i32 {
  let data = fs::read_to_string(filename).expect("Unable to read file");
  return data.parse::<i32>().unwrap();
}

pub fn read_strings(filename: &str) -> Vec<String> {
  fs::read_to_string(filename) 
      .unwrap()  // panic on possible file-reading errors
      .lines()  // split the string into an iterator of string slices
      .map(String::from)  // make each slice into a string
      .collect()  // gather them together into a vector
}
