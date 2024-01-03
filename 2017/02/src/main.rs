use advent;

fn main() {
  // Tests

  let test_data = vec!(
    "5 1 9 5".to_string(),
    "7 5 3".to_string(),
    "2 4 6 8".to_string(),
  );
  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  test.test_i32("checksum", 18, solve(&test_data));
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let input = advent::read_strings("02-input.txt");
  let solution = solve(&input);
  println!("Solution: {}", solution);
}

fn solve(input: &Vec<String>) -> i32 {
  let mut sum = 0;
  for line in input {
    let mut min = 0;
    let mut max = 0;
    for word in line.split_whitespace() {
      let num = word.parse::<i32>().unwrap();
      if num > max {
        max = num
      }
      if num < min || min == 0 {
        min = num
      }
    }
    sum += max - min;
  }
  return sum;
}
