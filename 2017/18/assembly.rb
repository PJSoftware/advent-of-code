# Syntax:
#
# `add X Y` increases register X by the value of Y.
# `mod X Y` sets register X to the remainder of dividing the value contained in register X by the value of Y (that is, it sets X to the result of X modulo Y).
# `mul X Y` sets register X to the result of multiplying the value contained in register X by the value of Y.
# `set X Y` sets register X to the value of Y.
#
# `jgz X Y` jumps with an offset of the value of Y, but only if the value of X is greater than zero. (An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction, and so on.)
#
# `snd X` plays a sound with a frequency equal to the value of X.
# `rcv X` recovers the frequency of the last sound played, but only when the value of X is not zero. (If it is zero, the command does nothing.)

class Assembly

  def reset
    @last_played = 0
    @index = 0
  end

  def initialize
    @register = Hash.new
    reset
  end

  def run(prog)
    reset
    loop do
      line = prog[@index]
      @index += 1
      cmd = line[0, 3]
      param = line[4, line.length-4].split(' ')

      case cmd
      when 'add'
        add(param[0],param[1])
      when 'mod'
        mod(param[0],param[1])
      when 'mul'
        mul(param[0],param[1])
      when 'set'
        set(param[0],param[1])

      when 'jgz'
        jgz(param[0],param[1])

      when 'snd'
        snd(param[0])
      when 'rcv'
        if rcv(param[0])
          return @last_played
        end
      
      else
        puts("command '#{line}' not recognised: CRASH!")
        exit 1
      end

    end
  end

  def init_reg(reg)
    if !@register.key?(reg)
      @register[reg] = 0
    end
  end

  def add(reg,val)
    init_reg(reg)
    @register[reg] += value(val)
  end
  
  def mod(reg,val)
    init_reg(reg)
    @register[reg] = @register[reg] % value(val)    
  end
  
  def mul(reg,val)
    init_reg(reg)
    @register[reg] *= value(val)
  end
  
  def set(reg,val)
    init_reg(reg)
    @register[reg] = value(val)
  end
  
  def jgz(val,offset)
    if value(val) > 0
      @index += value(offset)-1 # "-1" because we already stepped forward by 1
    end
  end
  
  def snd(val)
    @last_played = value(val)
  end
  
  def rcv(val)
    return value(val) != 0
  end

  def value(val)
    if /[a-z]/.match(val)
      init_reg(val)
      return @register[val]
    else
      return val.to_i
    end
  end
  
end
