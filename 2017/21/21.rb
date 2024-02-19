require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "grid"

start_data = Read.string("input.txt")
start_grid = Grid.new(start_data)

puts "Starting Tests:"
tests = Test.new
test_grid = start_grid
test_rules = Read.strings("input_test.txt")
test_grid.add_rules(test_rules)
tests.test("test start grid", 5, test_grid.on_count)

for i in 1..2
  test_grid.iterate
end
tests.test("test on_count after 2 iter", 12, test_grid.on_count)
tests.bail_on_fail

puts "All tests passed!\n---"

grid = start_grid
rules = Read::strings("input_data.txt")
grid.add_rules(rules)
for i in 1..5
  grid.iterate
end
puts "Cells on after 5 iterations: #{grid.on_count}"
