class Grid

  def initialize(linear)
    @grid = linear.split("/")
  end

  def add_rules(rules)
    @rules = rules
  end

  def on_count
    x = @grid.join('')
    x.gsub!(".", "")
    x.length
  end

  def iterate
  end

end
