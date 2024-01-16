module Read
  def self.string(filename)
    data = File.read(filename)
    return data
  end
  
  def self.strings(filename)
    return File.readlines(filename).map(&:chomp)
  end
end
