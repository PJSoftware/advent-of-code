require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "program"

def run_program(input)
  prog = Program.new
  input.each do |line|
    prog.run(line)
  end
  return prog
end

puts "Starting Tests:"
tests = Test.new()
test_input = Read::strings("input_test.txt")
test_answer = 1
test_prog = run_program(test_input)
tests.test("test data solution", test_answer, test_prog.max_value)
tests.test("highest test value", 10, test_prog.high_value)
tests.bail_on_fail()
puts "All tests passed!\n---"

input = Read::strings("input_data.txt")
prog = run_program(input)
puts "Solution: #{prog.max_value}"
puts "High Value: #{prog.high_value}"
