require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

ITERATIONS = 5000000

class Generator

  def initialize(factor,div)
    @factor = factor
    @div = div
    @dividend = 2147483647
    @value = 0
    @count = 0
  end

  def restart(value)
    @value = value
    @count = 0
  end

  def next
    loop do
      @value = (@value * @factor) % @dividend
      break if @value % @div == 0
    end
    return @value
  end

end

def matched(a, b)
  n = 16
  bin_a = a.to_s(2)
  bin_b = b.to_s(2)
  tail_a = bin_a.chars.last(n).join
  tail_b = bin_b.chars.last(n).join
  return tail_a == tail_b
end

gen_a = Generator.new(16807,4)
gen_b = Generator.new(48271,8)

puts "Starting Tests:"
tests = Test.new
test_a = 65
test_b = 8921

gen_a.restart(test_a)
gen_b.restart(test_b)

judge = 0
for i in 1..ITERATIONS
  val_a = gen_a.next
  val_b = gen_b.next

  case i
  when 1
    tests.test("generator A step #{i}", 1352636452, val_a)
    tests.test("generator B step #{i}", 1233683848, val_b)
  when 2
    tests.test("generator A step #{i}", 1992081072, val_a)
    tests.test("generator B step #{i}", 862516352, val_b)
  when 3
    tests.test("generator A step #{i}", 530830436, val_a)
    tests.test("generator B step #{i}", 1159784568, val_b)
  when 4
    tests.test("generator A step #{i}", 1980017072, val_a)
    tests.test("generator B step #{i}", 1616057672, val_b)
  when 5
    tests.test("generator A step #{i}", 740335192, val_a)
    tests.test("generator B step #{i}", 412269392, val_b)
  end

  if matched(val_a, val_b)
    judge += 1
  end

  if i % 200000 == 0
    puts("# of steps: #{i}")
  end
end

tests.test("final judge value", 309, judge)
tests.bail_on_fail

puts "All tests passed!\n---"

# Generator A starts with 634
# Generator B starts with 301
gen_a.restart(634)
gen_b.restart(301)

judge = 0
for i in 1..ITERATIONS
  val_a = gen_a.next
  val_b = gen_b.next
  if matched(val_a, val_b)
    judge += 1
  end

  if i % 200000 == 0
    puts("# of steps: #{i}")
  end
end

puts("Judge count: #{judge}")
