use advent;

fn main() {
  // Tests

  let test_data = Vec::<i32>::from([
    0,
    3,
    0,
    1,
    -3,
  ]);
  let test_answer1: i32 = 5;
  let test_answer2: i32 = 10;
  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  test.test_i32("jump count: test", test_answer1, jump_counter(test_data.clone(), 1));
  test.test_i32("jump count: test", test_answer2, jump_counter(test_data, 2));
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let jumps = advent::read_i32s("05-input.txt");
  println!("Number of jumps (1): {}", jump_counter(jumps.clone(), 1));
  println!("Number of jumps (2): {}", jump_counter(jumps, 2));
}

fn jump_counter(mut data: Vec<i32>, rules_version: i32) -> i32 {
  let mut jumps: i32 = 0;
  let mut index: i32 = 0;
  let size: i32 = data.len() as i32;

  while index < size {
    jumps += 1;
    let offset = data[index as usize];
    if rules_version == 1 || offset < 3 {
      data[index as usize] = offset+1;
    } else {
      data[index as usize] = offset-1;
    }
    index += offset;
  }
  jumps
}
