require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

class Spinlock
  attr_reader :next

  def initialize(step_size)
    @step_size = step_size
    @buffer = [0]
    @pos = 0
    @next = 1
  end

  def spin
    for step in 1..@step_size
      @pos = nextpos
    end
    @buffer.insert(@pos+1,@next)
    @next += 1
    @pos += 1
    return @buffer[nextpos]
  end

  def nextpos
    pos = @pos + 1
    if pos >= @buffer.length
      pos = 0
    end
    pos
  end

end

def solve(step_size, target_value)
  spinlock = Spinlock.new(step_size)
  next_val = -1
  loop do
    next_val = spinlock.spin
    break if spinlock.next > target_value
  end
  return next_val
end

puts "Starting Tests:"
tests = Test.new

tests.test("test data solution", 2, solve(3,7))
tests.test("test data solution", 5, solve(3,9))
tests.test("test data solution", 638, solve(3,2017))
tests.bail_on_fail

puts "All tests passed!\n---"

answer = solve(344,2017)
puts "Solution: #{answer}"
