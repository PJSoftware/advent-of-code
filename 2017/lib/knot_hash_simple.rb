class KnotHashS

  def initialize(size, lengths)
    @skip = 0

    @list = Array.new
    for i in 1..size do
      @list.push(i-1)
    end

    @lengths = Array.new
    lengths.split(",").each do |len|
      @lengths.push(len.to_i)
    end

    @tied = false
  end

  def tie
    if @tied
      return
    end
    @tied = true

    index = 0
    @lengths.each do |len|
      final = index + len - 1
      reverse(index, final)
      index += len+@skip
      index = wrap(index)
      @skip += 1
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
    return @list[0] * @list[1]
  end

  def wrap(index)
    while index >= @list.length
      index -= @list.length
    end
    return index
  end

end
