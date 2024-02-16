require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "swarm"

puts "Starting Tests:"
tests = Test.new

test_input = Read::strings("input_test.txt")
test_swarm = Swarm.new(test_input)
tests.test("test data solution", 0, test_swarm.closest)
tests.bail_on_fail

puts "All tests passed!\n---"

input = Read::strings("input_data.txt")
swarm = Swarm.new(input)
puts "Solution: #{swarm.closest}"
