require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "knot_hash_simple"

def solve(input)
  return input.length
end

puts "Starting Tests:"
tests = Test.new
test_input = Read::string("input_test.txt")
test_knot = KnotHashS.new(5, test_input)
test_knot.tie
tests.test("test data solution", 12, test_knot.checksum)
tests.bail_on_fail()
puts "All tests passed!\n---"

input = Read::string("input_data.txt")
knot = KnotHashS.new(256, input)
knot.tie
puts "Solution: #{knot.checksum}"
