require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "knot_hash_simple"
require_relative "knot_hash_complex"

def solve(input)
  return input.length
end

puts "Starting Tests:"
tests = Test.new
test_input = Read::string("input_test.txt")

test_knot_s = KnotHashS.new(5, test_input)
test_knot_s.tie
tests.test("test simple solution", 12, test_knot_s.checksum)

test_data = {
  "" => "a2582a3a0e66e6e86e3812dcb672a272",
  "AoC 2017" => "33efeb34ea91902bb2f59c9920caa6cd",
  "1,2,3" => "3efbe78a8d82f29979031a4aa0b16a9d",
  "1,2,4" => "63960835bcdc130f0b66d7ff4f6a5a8e",
}

test_data.each do |input, hash|
  test_knot_c = KnotHashC.new(input)
  test_knot_c.tie
  tests.test("test complex solution '#{input}'", hash, test_knot_c.checksum)
end

tests.bail_on_fail()
puts "All tests passed!\n---"

input = Read::string("input_data.txt")

knot_s = KnotHashS.new(256, input)
knot_s.tie
puts "Simple Solution: #{knot_s.checksum}"

knot_c = KnotHashC.new(input)
knot_c.tie
puts "Complex Solution: #{knot_c.checksum}"
