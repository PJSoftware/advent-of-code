use std::collections::HashMap;

pub struct Program<'a> {
  name: &str,
  weight: i32,
  parent: &'a Program,
  child: Vec<&'a Program>,
}

pub struct Tower<'a> {
  programs: HashMap<String,Program<'a>>,
}

impl Tower<'_> {
  pub fn new() -> Tower<'static> {
    Tower {
      programs: Default::default(),
    }
  }
}

//   impl Test {
//     pub fn new() -> Test {
//       Test {
//         run: 0,
//         failed: 0,
//       }
//     }
  
//     pub fn test_i32(&mut self, label: &str, exp: i32, got: i32) {
//       self.run += 1;
//       if got == exp {
//         println!("OK -- '{}' => {} / passed", label, got);
//       } else {
//         println!("FAIL -- '{}' / failed;\n  - exp '{}';\n  - got '{}'", label, exp, got);
//         self.failed += 1;
//       }
//     }
  
//     pub fn test_bool(&mut self, label: &str, exp: bool, got: bool) {
//       self.run += 1;
//       if got == exp {
//         println!("OK -- '{}' => {} / passed", label, got);
//       } else {
//         println!("FAIL -- '{}' / failed;\n  - exp '{}';\n  - got '{}'", label, exp, got);
//         self.failed += 1;
//       }
//     }
  
//     pub fn test_string(&mut self, label: &str, exp: &str, got: &str) {
//       self.run += 1;
//       if got == exp {
//         println!("OK -- '{}' => {} / passed", label, got);
//       } else {
//         println!("FAIL -- '{}' / failed;\n  - exp '{}';\n  - got '{}'", label, exp, got);
//         self.failed += 1;
//       }
//     }
  
//     pub fn bail_on_fail(&mut self) {
//       if self.failed > 0 {
//         println!("\nSample Data Tests: {}/{} failed\n", self.failed, self.run);
//         std::process::exit(1);
//       }
//       println!("");
//     }
    
//   }
  
// // pub fn add(left: usize, right: usize) -> usize {
// //     left + right
// // }

// // #[cfg(test)]
// // mod tests {
// //     use super::*;

// //     #[test]
// //     fn it_works() {
// //         let result = add(2, 2);
// //         assert_eq!(result, 4);
// //     }
// // }
