require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

class Program

  def initialize
    @register = Hash.new(0)
  end

  def max_value
    mv = -999
    @register.each do |name, value|
      if value > mv
        mv = value
      end
    end
    mv
  end

  def run(line)
    token = line.match /^(?<r1>[a-z]+) (?<cmd>inc|dec) (?<v1>-?\d+) if (?<r2>[a-z]+) (?<cmp>[<>!=]+) (?<v2>-?\d+)$/
    if token
      if self.compare(@register[token[:r2]], token[:cmp], token[:v2].to_i)
        self.modify(token[:r1], token[:cmd], token[:v1].to_i)
      end
    else
      puts "line does not match: #{line}"
    end
  end

  def compare(reg_val, comparison, value)
    case comparison
    when "<"
      return reg_val < value
    when ">"
      return reg_val > value
    when "<="
      return reg_val <= value
    when ">="
      return reg_val >= value
    when "!="
      return reg_val != value
    when "=="
      return reg_val == value
    else
      puts "Comparison method '#{comparison}' not recognised!"
      exit(1)
    end
  end

  def modify(reg, mod, value)
    case mod
    when "inc"
      @register[reg] += value
    when "dec"
      @register[reg] -= value
    else
      puts "Modification method '#{mod}' not recognised!"
      exit(2)
    end
  end

end

def solve(input)
  prog = Program.new
  input.each do |line|
    prog.run(line)
  end
  return prog.max_value
end

puts "Starting Tests:"
tests = Test.new()
test_input = Read::strings("input_test.txt")
test_answer = 1
tests.test("test data solution", test_answer, solve(test_input))
tests.bail_on_fail()
puts "All tests passed!\n---"

input = Read::strings("input_data.txt")
puts "Solution: #{solve(input)}"
