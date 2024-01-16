require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

class Program
  attr_reader :high_value

  def initialize
    @register = Hash.new(0)
    @high_value = 0
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

    if @register[reg] > @high_value
      @high_value = @register[reg]
    end
  end

end

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
