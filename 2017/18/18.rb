require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "assembly"

puts "Starting Tests:"
tests = Test.new

test_input = Read::strings("input_test.txt")
test_assem = Assembly.new
tests.test("test data solution", 4, test_assem.run(test_input))
tests.bail_on_fail

puts "All tests passed!\n---"

input = Read::strings("input_data.txt")
assem = Assembly.new
puts "Solution: #{assem.run(input)}"
