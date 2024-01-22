require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

class Firewall
  attr_reader :detected

  def initialize
    @scanners = Array.new
    @position = -1
    @severity = 0
    @max_layer = 0
    @detected = false
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
    @scanners.each do |scanner|
      if @position == scanner.layer && scanner.position == 0
        @detected = true
        @severity += scanner.severity
      end
      scanner.scan
    end
  end

  def reset_scanners
    @scanners.each do |scanner|
      scanner.reset
    end
  end

  def passage_severity(start_at)
    delay = start_at
    
    @severity = 0
    @position = -1
    @detected = false
    reset_scanners

    while delay > 0
      delay -= 1
      tick
    end
    
    @position = 0
    while @position <= @max_layer
      tick
      @position += 1
    end
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
  end

  def reset
    @position = 0
  end

  def scan
    @position += 1
    if @position == @maxpos
      @position = 0
    end
  end

end

def safe_passage_delay(fw, start_at = 1)
  delay = start_at
  while fw.passage_severity(delay) > 0 || fw.detected
    if delay % 1000 == 0 
      puts "Delay #{delay} -> detected: #{fw.detected}"
    end
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
tests.test("test data solution", 24, test_firewall.passage_severity(0))
tests.test("delay before detect", 10, safe_passage_delay(test_firewall))
tests.bail_on_fail
puts "All tests passed!\n---"

input = Read::strings("input_data.txt")
firewall = Firewall.new
input.each do |scanner|
  firewall.add_scanner(scanner)
end
puts "Solution 1: #{firewall.passage_severity(0)}"
puts "Solution 2: #{safe_passage_delay(firewall, 60000)}"
