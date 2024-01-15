require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "tower"

def find_root(input)
  tower = Tower.new()
  input.each do |prog|
    tower.add(prog)
  end
  return tower.root_name
end

# Like Rust, Ruby prefers snake_case; unlike Go's camelCase
test_data = Array[
  "pbga (66)",
  "xhth (57)",
  "ebii (61)",
  "havc (66)",
  "ktlj (57)",
  "fwft (72) -> ktlj, cntj, xhth",
  "qoyq (66)",
  "padx (45) -> pbga, havc, qoyq",
  "tknk (41) -> ugml, padx, fwft",
  "jptl (61)",
  "ugml (68) -> gyxo, ebii, jptl",
  "gyxo (61)",
  "cntj (57)",
]

tests = Test.new()

puts "Starting Tests:"
tests.test("root of test data", "tknk", find_root(test_data))
tests.bail_on_fail()
puts "All tests passed!"

input = Read.strings("input.txt")
puts "Solution: #{find_root(input)}"
