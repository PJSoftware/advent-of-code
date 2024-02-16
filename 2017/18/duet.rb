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
    @prog1 = Program.new(prog,1)
  end
  
  def start
    @prog0.start
    @prog1.start

    loop do
      while @prog0.output.length > 0 
        v = @prog0.output.shift
        # puts ">> Transfer #{v} from prog0 output to prog1 input"
        @prog1.input.push(v)
      end
      while @prog1.output.length > 0 
        v = @prog1.output.shift
        # puts ">> Transfer #{v} from prog1 output to prog0 input"
        @prog0.input.push(v)
      end

      if @prog0.input.length == 0 && @prog1.input.length == 0
        break
      end

      @prog0.resume
      @prog1.resume
    end

    return @prog1.send_count
  end

end

class Program
  attr_reader :waiting, :send_count, :exit
  attr_accessor :input, :output

  def initialize(prog,id)
    @send_count = 0
    @exit = false
    @code = prog
    @index = 0
    @register = Hash.new
    @waiting = false
    @reg_pending = ''

    @id = id
    @register['p'] = id

    @output = Array.new
    @input = Array.new
  end

  def start
    return run(false)
  end

  def resume
    return run(true)
  end

  def done
    return @waiting || @exit
  end

  # private

  def run(resume)
    if resume && @waiting
      # puts "Prog #{@id}: resuming, reading reg '#{@reg_pending}'"
      if !receive(@reg_pending)
        # puts "Prog #{@id}: input queue STILL empty; waiting for reg '#{@reg_pending}'"
        return
      end
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
        send(param[0])
      when 'rcv'
        if !receive(param[0])
          # puts "Prog #{@id}: input queue empty; waiting for reg '#{param[0]}'"
          return
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
    @send_count += 1
    v = value(val)
    # puts "Prog #{@id} sending value: #{v}"
    @output.push(v)
  end
  
  def receive(reg)
    # puts "Prog #{@id} trying to receive into reg #{reg}"
    if @input.length > 0
      val = @input.shift
      # puts "- shift #{val} from input"
      @register[reg] = val
      return true
    else
      @reg_pending = reg
      @waiting = true
      # puts "- input queue empty; program pausing"
      return false
    end
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
