require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "hexgrid"

def solve(input)
  return input.length
end

puts "Starting Tests:"
tests = Test.new

test_paths = {
  "ne,ne,ne" => 3,
  "ne,ne,sw,sw" => 0,
  "ne,ne,s,s" => 2,
  "se,sw,se,sw,sw" => 3,
}
test_paths.each do |path, dist|
  hg = HexGrid.new
  hg.follow_path(path)
  tests.test("path '#{path}' distance", dist, hg.steps_from_origin)
end
tests.bail_on_fail

puts "All tests passed!\n---"

input = Read::string("input_data.txt")
hg = HexGrid.new
hg.follow_path(input)
puts "Solution: #{hg.steps_from_origin}"
puts "Farthest: #{hg.farthest}"
