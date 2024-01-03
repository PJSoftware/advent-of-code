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

pub struct Data {
  string: String,
}

impl Data {
  pub fn new() -> Data {
    Data {
      string: String::new(),
    }
  }

  pub fn read_string(&mut self, filename: &str) {
    let data = fs::read_to_string(filename);
    self.string = data.expect("Unable to read file");
  }

  pub fn string(&mut self) -> String {
    return self.string.clone();
  }
  
}

// func inputFile(num string) string {
// 	pwd := os.Getenv("PWD")
// 	return fmt.Sprintf("%s/2016/%s/%s-input.txt", pwd, num, num)
// }

// // InputString reads the contents of the input file as a single string
// func InputString(num string) string {
// 	fn := inputFile(num)
// 	b, err := os.ReadFile(fn)
// 	if err != nil {
// 		log.Fatalf("error reading '%s': %v", fn, err)
// 	}

// 	return string(b)
// }
