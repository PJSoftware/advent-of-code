Vec3 = Struct.new(:x, :y, :z)

class Particle
  attr_reader :num, :dist, :acceleration

  def initialize(p_num, p_str, v_str, a_str)
    @num = p_num

    x,y,z = parse(p_str)
    @pos = Vec3.new(x,y,z)
    
    x,y,z = parse(v_str)
    @vel = Vec3.new(x,y,z)
    
    x,y,z = parse(a_str)
    @accel = Vec3.new(x,y,z)

    @acceleration = @accel.x.abs + @accel.y.abs + @accel.z.abs
    distance
  end

  def parse(str)
    coord_str = str.split(",", -1)
    return coord_str[0].to_i, coord_str[1].to_i, coord_str[2].to_i
  end

  def tick
    @vel.x += @accel.x
    @vel.y += @accel.y
    @vel.z += @accel.z
    @pos.x += @vel.x
    @pos.y += @vel.y
    @pos.z += @vel.z
  end

  def distance
    @dist = @pos.x.abs + @pos.y.abs + @pos.z.abs
    return @dist
  end
  
  def velocity
    return @vel.x.abs + @vel.y.abs + @vel.z.abs
  end
end

class Swarm

  def initialize(data)
    @particles = Array.new
    @all_moving_away = false

    p_num = 0
    for p_data in data
      p = /p=<(.+)>, v=<(.+)>, a=<(.+)>/.match(p_data)
      particle = Particle.new(p_num, p[1],p[2],p[3])
      @particles.push(particle)
      p_num += 1
    end
  end

  def tick
    @min_dist = -1
    @nearest = 0
    @min_vel = -1
    @slowest = 0
    @min_acc = -1
    @slowacc = 0
    @all_moving_away = true

    for p in @particles
      old_dist = p.dist
      p.tick
      dist = p.distance

      if dist <= old_dist
        @all_moving_away = false
      end

      if @min_dist == -1 || dist < @min_dist
        @nearest = p.num
        @min_dist = dist
      end

      vel = p.velocity
      if @min_vel == -1 || vel < @min_vel
        @slowest = p.num
        @min_vel = vel
      end

      acc = p.acceleration
      if @min_acc == -1 || acc < @min_acc
        @slowacc = p.num
        @min_acc = acc
      end
    end
  end

  def closest
    no_change = 0
    nearest = -1

    loop do
      tick
      puts "Slowest: #{@slowest}(#{@min_vel}) -- Nearest: #{@nearest}(#{@min_dist}) -- Accel: #{@slowacc}(#{@min_acc}) -- #{@all_moving_away}"
      if @all_moving_away && @slowest == @nearest && @slowacc == @slowest
        break
      end
    end

    return @nearest
  end

end
