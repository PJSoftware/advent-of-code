class Node
  attr_accessor :parent, :name, :weight

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

end

class Tower

  def initialize
    @nodes = Hash.new
    @root = nil
  end

  def add_node(name, weight)
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
  
end

