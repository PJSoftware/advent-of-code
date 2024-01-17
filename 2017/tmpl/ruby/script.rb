require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

def solve(input)
  return input.length
end

puts "Starting Tests:"
tests = Test.new

test_input = Read::strings("input_test.txt")
test_answer = 1
tests.test("test data solution", test_answer, solve(test_input))
tests.bail_on_fail

puts "All tests passed!\n---"

input = Read::strings("input_data.txt")
puts "Solution: #{solve(input)}"
