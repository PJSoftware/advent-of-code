class KnotHash

  def initialize(length_prefix)
    @skip = 0

    @list = Array.new
    for i in 1..256 do
      @list.push(i-1)
    end

    @lengths = Array.new
    length_prefix.each_byte do |ch|
      @lengths.push(ch)
    end
    suffix = [17,31,73,47,23]
    @lengths.push(*suffix)

    @tied = false
  end

  def tie
    if @tied
      return
    end
    @tied = true

    index = 0
    for i in 1..64
      @lengths.each do |len|
        final = index + len - 1
        reverse(index, final)
        index += len+@skip
        index = wrap(index)
        @skip += 1
      end
    end
  end

  def reverse(first, last)
    mid = (first+last)/2
    for idx in first..mid do
      i = wrap(idx)
      j = wrap(last)
      last -= 1
      if i != j
        x = @list[i]
        @list[i] = @list[j]
        @list[j] = x
      end
    end
  end

  def checksum
    cs = ""
    for i in 0..15
      cs += hex_xor(i*16, i*16+15)
    end
    return cs
  end

  def hex_xor(first, last)
    num = @list[first]
    for i in first+1 .. last
      num = num ^ @list[i]
    end
    hex = num.to_s(16)
    if hex.length == 1
      hex = "0" + hex
    end
    return hex
  end

  def wrap(index)
    while index >= @list.length
      index -= @list.length
    end
    return index
  end

end
