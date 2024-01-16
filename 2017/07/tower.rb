class Node
  attr_accessor :parent, :name, :weight
  attr_reader :children

  def initialize(name, weight)
    @name = name
    @weight = weight
    @parent = nil
    @children = []
  end

  def add_child(node)
    node.parent = self
    @children.append(node)
  end

  def total_weight
    total = 0
    total += @weight
    if @children.length > 0
      @children.each do |child|
        total += child.total_weight
      end
    end
    total
  end

end

class Tower

  def initialize
    @nodes = Hash.new
    @root = nil
  end

  def add_node(name, weight_str)
    weight = weight_str.to_i
    if @nodes.has_key?(name)
      node = @nodes[name]
      if node.weight == 0
        node.weight = weight
      end
      return node
    else
      node = Node.new(name, weight)
      @nodes[name] = node
      return node
    end
  end

  def add(ident)
    m = ident.match /^(?<name>\S+) \((?<weight>\d+)\)(?<spawn>.*)$/
    node = add_node(m[:name],m[:weight])

    if m[:spawn] != ""
      spawn = m[:spawn].delete_prefix(" -> ")
      children = spawn.split(/, /)
      children.each do |child|
        child_node = add_node(child, 0)
        node.add_child child_node
        if node.parent == nil
          @root = node
        end
        while @root.parent != nil
          @root = @root.parent
        end
      end
    end
  end

  def root_name
    if @root == nil
      return ""
    end
    @root.name
  end
  
  def total_weight
    @root.total_weight
  end

  def balance
    node, weight = find_discrepancy(@root)
    return node.name, weight
  end

  def find_discrepancy(node)
    loop do
      puts "Investigating #{node.name}:"
      weights = Hash.new(0)
      nodes = Hash.new
      child_nodes = node.children
      if child_nodes.length == 0
        return nil, 0, false
      end

      child_nodes.each do |child|
        weight = child.total_weight
        weights[weight] += 1
        nodes[weight] = child
      end

      diff = 0
      same = 0
      weights.each do |key, value|
        if value == 1
          diff = key
        else
          same = key
        end
      end
      if diff == 0
        puts "- all children of #{node.name} weigh #{same}"
        return nil, same, false
      end

      next_node, next_weight, answer = find_discrepancy(nodes[diff])
      if answer
        return next_node, next_weight, answer
      end
      
      if next_node == nil
        found = nodes[diff]
        adjusted = found.weight + same - diff
        puts "- node #{found.name} weight needs to be #{adjusted}"
        return found, adjusted, true
      end

    end
  end

end

