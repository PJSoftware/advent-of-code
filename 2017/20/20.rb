require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "swarm"

puts "Starting Tests:"
tests = Test.new

test1_input = Read::strings("input_test.txt")
test1_swarm = Swarm.new(test1_input)
tests.test("test1 data solution", 0, test1_swarm.closest)

test2_input = Read::strings("input_test_collisions.txt")
test2_swarm = Swarm.new(test2_input)
tests.test("test2 data remaining", 1, test2_swarm.remaining)

tests.bail_on_fail

puts "All tests passed!\n---"

input = Read::strings("input_data.txt")
swarm1 = Swarm.new(input)
puts "Solution 1: #{swarm1.closest}"
swarm2 = Swarm.new(input)
puts "Solution 2: #{swarm2.remaining}"
