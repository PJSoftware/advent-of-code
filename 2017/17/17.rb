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

  def after_zero
    pos = 0
    loop do
      break if @buffer[pos] == 0
      pos += 1
    end
    pos += 1
    if pos == @buffer.length
      pos = 0
    end
    puts("position of value after zero = #{pos}")
    return @buffer[pos]
  end

  def after_pos
    return @buffer[nextpos]
  end

  def spin
    @pos += @step_size
    while @pos >= @buffer.length
      @pos -= @buffer.length
    end
    @buffer.insert(@pos+1,@next)
    @next += 1
    @pos += 1
  end

  def nextpos
    pos = @pos + 1
    if pos >= @buffer.length
      pos = 0
    end
    pos
  end

end

class BufferlessSpinlock
  attr_reader :next

  def initialize(step_size)
    @step_size = step_size
    @pos = 0
    @next = 1
    @zero_pos = 0
    @after_zero = 0
    @len = 1
  end

  def after_zero
    return @after_zero
  end

  def spin
    @pos += @step_size
    while @pos >= @len
      @pos -= @len
    end
    if @pos == @zero_pos
      @after_zero = @next
    end
    @len += 1
    @next += 1
    @pos += 1
  end

  def nextpos
    pos = @pos + 1
    if pos >= @len
      pos = 0
    end
    pos
  end

end

def solve(step_size, target_value)
  spinlock = Spinlock.new(step_size)
  next_val = -1
  loop do
    spinlock.spin
    nv = spinlock.next
    if nv % 500000 == 0
      puts("Loop has run #{nv}/#{target_value} times (#{nv.to_f*100.0/target_value.to_f}%)")
    end
    break if nv > target_value
  end
  return spinlock
end

def solve2(step_size, target_value)
  spinlock = BufferlessSpinlock.new(step_size)
  next_val = -1
  loop do
    spinlock.spin
    nv = spinlock.next
    break if nv > target_value
  end
  return spinlock
end

puts "Starting Tests:"
tests = Test.new

tests.test("test data solution", 2, solve(3,7).after_pos)
tests.test("test data solution", 5, solve(3,9).after_pos)
tests.test("test data solution", 638, solve(3,2017).after_pos)
tests.bail_on_fail

puts "All tests passed!\n---"

part1 = solve(344,2017)
puts "Solution 1: #{part1.after_pos}"
puts "Solution 1(b): #{part1.after_zero}"
az = part1.after_zero

part2 = solve2(344,2017)
puts "Solution 1(c): #{part2.after_zero}"
if part2.after_zero != az
  puts("** Expected #{az}")
  exit 2
end

part2_az = solve2(344,50000000).after_zero
puts "Solution 2: #{part2_az}"
