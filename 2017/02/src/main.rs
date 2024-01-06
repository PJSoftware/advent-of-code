use advent;

fn main() {
  // Tests

  let test_data1 = vec!(
    "5 1 9 5".to_string(),
    "7 5 3".to_string(),
    "2 4 6 8".to_string(),
  );
  let test_data2 = vec!(
    "5 9 2 8".to_string(),
    "9 4 7 3".to_string(),
    "3 8 6 5".to_string(),
  );

  let mut test = advent::Test::new();

  println!("Starting Tests:\n");
  test.test_i32("checksum type1", 18, check_sum1(&test_data1));
  test.test_i32("checksum type2", 9, check_sum2(&test_data2));
  test.bail_on_fail();
  println!("All tests passed!\n");

  // Solution

  let input = advent::read_strings("02-input.txt");
  println!("Solution 1: {}", check_sum1(&input));
  println!("Solution 2: {}", check_sum2(&input));
}

fn check_sum1(input: &Vec<String>) -> i32 {
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

fn check_sum2(input: &Vec<String>) -> i32 {
  let mut sum = 0;
  for line1 in input {
    let line2 = line1.clone();
    for word1 in line1.split_whitespace() {
      let num1 = word1.parse::<i32>().unwrap();
      for word2 in line2.split_whitespace() {
        if word2 == word1 {
          continue;
        }
        let num2 = word2.parse::<i32>().unwrap();
        if num1 % num2 == 0 {
          // println!("Value {}/{} = {} added to sum", num1, num2, num1/num2);
          sum += num1 / num2;
          break;
        }
      }
    }
  }
  return sum;
}
