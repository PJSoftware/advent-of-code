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
  let test_answer: i32 = 5;
  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  test.test_i32("jump count: test", test_answer, jump_counter(test_data));
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let jumps = advent::read_i32s("05-input.txt");
  println!("Number of jumps: {}", jump_counter(jumps));
}

fn jump_counter(mut data: Vec<i32>) -> i32 {
  let mut jumps: i32 = 0;
  let mut index: i32 = 0;
  let size: i32 = data.len() as i32;

  while index < size {
    jumps += 1;
    let current = data[index as usize];
    data[index as usize] = current+1;
    index += current;
  }
  jumps
}
