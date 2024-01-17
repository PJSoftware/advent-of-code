class HexGrid

  attr_reader :farthest

  # To model this grid we shall use cube coordinates per https://www.redblobgames.com/grids/hexagons/
  # q is N/S, with N positive (N is "0 deg" up the page)
  # r is SE/NW, with SE positive (SE is "120 deg" to the right of N)
  # s is SW/NE, with SW positive (SW is "240 deg", 120 deg to the right of SE)
  # This makes our positive direction clockwise.

  # The default starting position is (0,0,0)
  def initialize
    @q = 0
    @r = 0
    @s = 0

    @farthest = 0
  end

  def follow_path(path)
    path.split(",").each do |move|
      case move
      when "n" # positive q
        @r -= 1
        @s += 1
      when "s" # negative q
        @r += 1
        @s -= 1
      when "se" # positive r 
        @q += 1
        @s -= 1
      when "nw" # negative r
        @q -= 1
        @s += 1
      when "sw" # positive s
        @q -= 1
        @r += 1
      when "ne" # negative s
        @q += 1
        @r -= 1
      else
        puts "WTF is '#{path}'?"
        exit 1
      end

      cd = steps_from_origin
      if cd > @farthest
        @farthest = cd
      end
    end
  end

  # I'm fairly sure this is not correct
  def steps_from_origin
    return [@q.abs,@r.abs,@s.abs].max
  end

end
