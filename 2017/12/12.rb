require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

class Group
  def initialize
    @nodes = Array.new
  end

  def add_node(data)
    node = Node.new(data)
    @nodes.push(node)
  end

  def set_connected(id)
    @nodes.each do |node|
      if node.id == id
        node.connected = true
        return
      end
    end
  end

  def count_connected(source)
    rv = 0
    loop do
      mod = 0
      @nodes.each do |node|
        if !node.counted
          if node.id == source || node.connected
            rv += 1
            mod += 1
            node.counted = true
            node.neighbours.each do |node_id|
              set_connected(node_id)
            end
          end
        end
      end
      if mod == 0
        return rv
      end
    end
  end

  def number_groups(already_counted)
    rv = already_counted

    loop do
      check = -1
      @nodes.each do |node|
        if !node.counted
          check = node.id
          break
        end
      end

      if check == -1
        return rv
      else
        rv += 1
        count_connected(check)
      end
    end
  end

end

class Node
  attr_reader :id, :neighbours
  attr_accessor :counted, :connected

  def initialize(data)
    comms = data.match(/^(?<id>\d+) \<-\> (?<nn>[\d, ]+)$/)
    if comms
      @id = comms[:id].to_i
      @counted = false
      @connected = false
      @neighbours = Array.new
      comms[:nn].split(", ").each do |neighbour|
        @neighbours.push(neighbour.to_i)
      end
    else
      fput "Unrecognised comms data: '#{data}"
    end
  end
end

def analyse_data(input)
  group = Group.new
  input.each do |data|
    group.add_node(data)
  end

  return group.count_connected(0)
end

puts "Starting Tests:"
tests = Test.new

test_input = Read::strings("input_test.txt")
test_group = Group.new
test_input.each do |data|
  test_group.add_node(data)
end

tests.test("test data solution", 6, test_group.count_connected(0))
tests.test("test num groups", 2, test_group.number_groups(1))
tests.bail_on_fail
puts "All tests passed!\n---"

input = Read::strings("input_data.txt")
group = Group.new
input.each do |data|
  group.add_node(data)
end
puts "Connected: #{group.count_connected(0)}"
puts "Group Count: #{group.number_groups(1)}"
