require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "grid"

puts "Starting Tests:"
tests = Test.new

test_input = Read::strings("input_test.txt")
test_grid = Grid.new(test_input)
test_answer = "ABCDEF"
tests.test("test data solution", test_answer, test_grid.follow)
tests.test("test data moves", 38, test_grid.moves)
tests.bail_on_fail

puts "All tests passed!\n---"

input = Read::strings("input_data.txt")
grid = Grid.new(input)
puts "Solution 1: #{grid.follow}"
puts "Solution 1: #{grid.moves}"
