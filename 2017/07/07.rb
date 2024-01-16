require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "tower"

def construct_from(input)
  tower = Tower.new()
  input.each do |prog|
    tower.add(prog)
  end
  return tower
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
test_tower = construct_from(test_data)
tests.test("root of test data", "tknk", test_tower.root_name)
puts "Weight of test tower: #{test_tower.total_weight}"
name, weight = test_tower.balance()
tests.test("balance #{name}", 60, weight)
tests.bail_on_fail()
puts "All tests passed!\n---"

input = Read.strings("input.txt")
tower = construct_from(input)
puts "Solution: #{tower.root_name}"
puts "Weight of tower: #{tower.total_weight}"
name, weight = tower.balance()
puts "Balance #{name}; set to: #{weight}"
