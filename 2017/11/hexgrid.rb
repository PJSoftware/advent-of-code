class HexGrid

  # To model this grid we shall use three axes: x, y, z
  # x is N/S, with N positive (N is "0 deg" up the page)
  # y is NE/SW, with NE positive (NE is "60 deg" to the right of N)
  # z is SE/NW, with SE positive (SE is "120 deg", 60 deg to the right of NE)
  # This makes our positive direction clockwise.

  # The default starting position is (0,0,0)
  def initialize
    @x = 0
    @y = 0
    @z = 0
  end

  def follow_path(path)
    path.split(",").each do |move|
      case move
      when "n"
        @x += 1
      when "s"
        @x -= 1
      when "ne"
        @y += 1
      when "sw"
        @y -= 1
      when "se"
        @z += 1
      when "nw"
        @z -= 1
      else
        puts "WTF is '#{path}'?"
        exit 1
      end
    end
  end

  # I'm fairly sure this is not correct
  def steps_from_origin
    puts "Coordinates: (#{@x},#{@y},#{@z})"
    return @x.abs + @y.abs + @z.abs
  end

end
