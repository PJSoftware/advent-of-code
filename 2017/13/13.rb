require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

class Firewall
  def initialize
    @scanners = Array.new
    @position = -1
    @severity = 0
    @max_layer = 0
  end

  def add_scanner(data)
    match = data.match(/^(?<layer>\d+): (?<range>\d+)$/)
    if match
      layer = match[:layer].to_i
      scanner = Scanner.new(layer, match[:range].to_i)
      if @max_layer < layer
        @max_layer = layer
      end
      @scanners.push(scanner)
    end
  end

  def tick
    puts "TICK:"
    @scanners.each do |scanner|
      if @position == scanner.layer && scanner.position == 0
        puts ">> Detected at layer #{scanner.layer}"
        @severity += scanner.severity
      end
      scanner.scan
    end
  end

  def reset_scanners
    puts "RESET:"
    @scanners.each do |scanner|
      scanner.reset
      puts " >>> Scanner #{scanner.layer} at position #{scanner.position}"
    end
  end

  def passage_severity(start_at)
    delay = start_at
    
    puts("If we start after #{start_at} picoseconds:")
    @severity = 0
    @position = -1
    reset_scanners
    # exit 3
    while delay > 0
      delay -= 1
      puts "WAIT #{delay}"
      tick
    end
    
    @position = 0
    while @position <= @max_layer
      puts "\nCurrent position: layer #{@position}"
      tick
      puts "Crossing FW @ #{@position}: total severity #{@severity}"
      @position += 1
    end

    if start_at == 12
      exit 2
    end
    puts(" - Severity of passage is #{@severity}")
    return @severity
  end

end

class Scanner
  attr_reader :layer, :severity
  attr_accessor :position

  def initialize(layer, range)
    @layer = layer
    @range = range
    @position = 0
    @maxpos = (range-1)*2
    @severity = layer*range
    # puts "New scanner: layer #{@layer}, severity #{@severity}"
  end

  def reset
    @position = 0
  end

  def scan
    puts " > Scanner #{layer} at position #{@position}/#{@maxpos-1}"
    @position += 1
    if @position == @maxpos
      @position = 0
    end
  end

end

def safe_passage_delay(fw)
  delay = 1
  while fw.passage_severity(delay) > 0
    delay += 1
  end
  return delay
end

puts "Starting Tests:"
tests = Test.new

test_input = Read::strings("input_test.txt")
test_firewall = Firewall.new
test_input.each do |scanner|
  test_firewall.add_scanner(scanner)
end
# tests.test("test data solution", 24, test_firewall.passage_severity(0))
tests.test("test data solution", 10, safe_passage_delay(test_firewall))
tests.bail_on_fail

exit(1)
puts "All tests passed!\n---"

input = Read::strings("input_data.txt")
firewall = Firewall.new
input.each do |scanner|
  firewall.add_scanner(scanner)
end
puts "Solution: #{firewall.passage_severity(0)}"
# puts "Solution: #{safe_passage_delay(firewall)}"
