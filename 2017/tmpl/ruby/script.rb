require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

def solve(input)
  return input.length
end

test_data = Hash[
  "123" => 3,
  "456" => 3,
]

tests = Test.new()

puts "Starting Tests:"
test_data.each do |input, answer|
  tests.test("sample: #{input}", answer, solve(input))
end
tests.bail_on_fail()
puts "All tests passed!\n---"

input = Read::string("input.txt")
puts "Solution: #{solve(input)}"
