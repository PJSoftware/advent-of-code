require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

require_relative "../lib/knot_hash"

class Disk
  attr_reader :grid

  def initialize(key)
    @grid = Array.new
    for i in 0..127 do
      k = key + "-" + i.to_s
      knot = KnotHash.new(k)
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

class Grid
  attr_reader :regions

  def initialize(disk)
    @grid = Array.new
    @regions = 0

    disk.grid.each do |row|
      @grid.push(hex_to_bin(row).chars)
    end
  end
  
  def flood_fill
    total = 0
    for i in 0..127 do
      for j in 0..127 do
        if @grid[i][j] == "1"
          @regions += 1
          size = fill(i,j)
          # puts("Region ##{@regions} has #{size} cells")
          total += size
        elsif @grid[i][j] == "0"
          @grid[i][j] = " "
        end
      end
      # puts @grid[i].join()
    end
    puts "Total used cells: #{total}"
  end

  def fill(i,j)
    @grid[i][j] = "X"
    size = 1
    if i > 0 && @grid[i-1][j] == "1"
      size += fill(i-1,j)
    end
    if j > 0 && @grid[i][j-1] == "1"
      size += fill(i,j-1)
    end
    if i < 127 && @grid[i+1][j] == "1"
      size += fill(i+1,j)
    end
    if j < 127 && @grid[i][j+1] == "1"
      size += fill(i,j+1)
    end
    return size
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
test_grid = Grid.new(test_disk)
test_grid.flood_fill
tests.test("test num regions", 1242, test_grid.regions) ## <- answer given
# tests.test("test num regions", 1229, test_grid.regions) ## <- actual answer?
tests.bail_on_fail

puts "All tests passed!\n---"

input = Read::string("input_data.txt")
disk = Disk.new(input)
puts "Squares used: #{disk.used}"

grid = Grid.new(disk)
grid.flood_fill
puts "Regions used: #{grid.regions}"
