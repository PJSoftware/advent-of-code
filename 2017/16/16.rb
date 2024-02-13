require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

def dance(lineup, steps)
  return lineup.length
end

puts "Starting Tests:"
tests = Test.new

test_input = Read::string("input_test.txt")
test_steps = test_input.split(',',-1)
tests.test("test solution", 'baedc', dance('abcde',test_steps))
tests.bail_on_fail

puts "All tests passed!\n---"

input = Read::string("input_data.txt")
steps = input.split(',',-1)
final_lineup = dance('abcdefghijklmnop', steps)
puts "Lineup After Dance: #{final_lineup}"
