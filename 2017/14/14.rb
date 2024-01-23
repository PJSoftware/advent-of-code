require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "../lib/knot_hash"

class Disk

  def initialize(key)
    @grid = Array.new
    for i in 0..127 do
      knot = KnotHash.new(key + "-" + i.to_s)
      knot.tie
      @grid.push(knot.checksum)
    end
  end

  def used
    squares = 0
    @grid.each do |row|
      squares += digit_sum(hex_to_bin(row))
    end
    return squares
  end
  
  def digit_sum(s)
    rv = 0
    s.each_char do |c| 
      rv += c.to_i
    end
    rv
  end

end

def hex_to_bin(h)
  b = ""
  h.each_char do |c|
    case c
    when "0"
      b += "0000"
    when "1"
      b += "0001"
    when "2"
      b += "0010"
    when "3"
      b += "0011"
    when "4"
      b += "0100"
    when "5"
      b += "0101"
    when "6"
      b += "0110"
    when "7"
      b += "0111"
    when "8"
      b += "1000"
    when "9"
      b += "1001"
    when "a", "A"
      b += "1010"
    when "b", "B"
      b += "1011"
    when "c", "C"
      b += "1100"
    when "d", "D"
      b += "1101"
    when "e", "E"
      b += "1110"
    when "f", "F"
      b += "1111"
    end
  end
  b
end

puts "Starting Tests:"
tests = Test.new

test_input = Read::string("input_test.txt")
test_disk = Disk.new(test_input)
tests.test("hex2bin: A0", "10100000", hex_to_bin("A0"))
tests.test("hex2bin: A0", "0000111111110001", hex_to_bin("0FF1"))
tests.test("test num squares", 8108, test_disk.used)
tests.bail_on_fail

puts "All tests passed!\n---"

input = Read::string("input_data.txt")
disk = Disk.new(input)
puts "Squares used: #{disk.used}"
