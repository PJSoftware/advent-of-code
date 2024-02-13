# Syntax:
#
# `add X Y` increases register X by the value of Y.
# `mod X Y` sets register X to the remainder of dividing the value contained in register X by the value of Y (that is, it sets X to the result of X modulo Y).
# `mul X Y` sets register X to the result of multiplying the value contained in register X by the value of Y.
# `set X Y` sets register X to the value of Y.
#
# `jgz X Y` jumps with an offset of the value of Y, but only if the value of X is greater than zero. (An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction, and so on.)
#
# `snd X` send value of X to message queue.
# `rcv X` receive value from other program's message queue and place in register X.

class Duet
  
  def initialize(prog)
    @prog0 = Program.new(prog,0)
    @queue0 = Array.new
    
    @prog1 = Program.new(prog,1)
    @queue1 = Array.new
  end
  
  def start
    v0 = @prog0.start
    if !@prog0.waiting
      @queue0.push(v0)
    end
    v1 = @prog1.start
    if !@prog1.waiting
      @queue1.push(v1)
    end

    loop do

      if @prog0.waiting
        if @queue1.length > 0
          v1 = @queue1.shift
          v0 = @prog0.send(v1)
          if !@prog0.waiting
            @queue0.push(v0)
          end
        end
      elsif !@prog0.exit
        v0 = @prog0.resume()
        if !@prog0.waiting
          @queue0.push(v0)
        end
      end

      if @prog1.waiting
        if @queue0.length > 0
          v0 = @queue0.shift
          v1 = @prog1.send(v0)
          if !@prog1.waiting
            @queue1.push(v1)
          end
        end
      elsif !@prog1.exit
        v1 = @prog1.resume()
        if !@prog1.waiting
          @queue1.push(v1)
        end
      end

      puts("> #{@queue0.length} #{@queue1.length} #{@prog0.done} #{@prog1.done}")
      break if @prog0.done && @prog1.done && @queue1.length == 0
    end

    return @prog1.send_count
  end

end

class Program
  attr_reader :waiting, :send_count, :exit

  def initialize(prog,id)
    @send_count = 0
    @exit = false
    @code = prog
    @index = 0
    @register = Hash.new
    @waiting = false
    @waiting_for_reg = ''

    @register['p'] = id
  end

  def start
    return run(false,0)
  end

  def resume()
    return run(false,0)
  end

  def send(val)
    return run(true,val)
  end

  def done
    return @waiting || @exit
  end

  # private

  def run(resume, val)
    if resume && @waiting
      @register[@waiting_for_reg] = val
      @waiting = false
    end

    loop do
      if @index >= @code.length
        @exit = true
        return 0
      end

      line = @code[@index]
      @index += 1
      cmd = line[0, 3]
      param = line[4, line.length-4].split(' ')

      case cmd
      when 'add'
        add(param[0],param[1])
      when 'mod'
        modulo(param[0],param[1])
      when 'mul'
        multiply(param[0],param[1])
      when 'set'
        set(param[0],param[1])

      when 'jgz'
        jump_gz(param[0],param[1])

      when 'snd'
        return send(param[0])
      when 'rcv'
        return receive(param[0])
      
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
  
  def modulo(reg,val)
    init_reg(reg)
    @register[reg] = @register[reg] % value(val)    
  end
  
  def multiply(reg,val)
    init_reg(reg)
    @register[reg] *= value(val)
  end
  
  def set(reg,val)
    init_reg(reg)
    @register[reg] = value(val)
  end
  
  def jump_gz(val,offset)
    if value(val) > 0
      @index += value(offset)-1 # "-1" because we already stepped forward by 1
    end
  end
  
  def send(val)
    @waiting = false
    @send_count += 1
    return value(val)
  end
  
  def receive(reg)
    @waiting_for_reg = reg
    @waiting = true
    return 0
  end

  def value(val)
    if /[a-z]/.match(val.to_s)
      init_reg(val)
      return @register[val]
    else
      return val.to_i
    end
  end
  
end
