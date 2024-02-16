class Grid
  attr_reader :moves

  # Directions are [delta_row, delta_col]
  @@up    = [-1,0]
  @@down  =  [1,0]
  @@left  =  [0,-1]
  @@right =  [0,1]

  def initialize(data)
    @max_rows = data.length
    @max_cols = 0
    for row in data
      cols = row.length
      if cols > @max_cols
        @max_cols = cols
      end
    end
    @grid = Array.new
    for row in data
      grid_row = row.chars
      while grid_row.length < @max_cols
        grid_row.push(" ")
      end
      @grid.push(grid_row)
    end

    @row = 0
    @col = 0
    for col in 0..@max_cols-1
      if @grid[@row][col] == "|"
        @col = col
        @dir = @@down
        @path = ""
        @moves = 0
        break
      end
    end
  end

  def follow
    while move
      cell = @grid[@row][@col]

      if cell == '|' || cell == '-'
        next
      end

      if cell == '+'
        if @dir[1] == 0
          if is_path(@@left)
            @dir = @@left
          else
            @dir = @@right
          end
        else
          if is_path(@@up)
            @dir = @@up
          else
            @dir = @@down
          end
        end
        next
      end

      @path += cell
    end

    return @path
  end

  def is_path(dir)
    row = @row + dir[0]
    col = @col + dir[1]
    if row < 0 || row >= @max_rows
      return false
    end
    if col < 0 || col >= @max_cols
      return false
    end
    return @grid[row][col] != ' '
  end

  def move
    row = @row + @dir[0]
    col = @col + @dir[1]
    if row < 0 || row >= @max_rows
      return false
    end
    if col < 0 || col >= @max_cols
      return false
    end

    @row = row
    @col = col
    @moves += 1

    return @grid[@row][@col] != ' '
  end

end
