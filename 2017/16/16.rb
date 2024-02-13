require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

def dance(lineup, steps)
  row = lineup.chars
  for step in steps
    move = step.chr
    step = step[1..-1]
    case move
    when 's'
      row = spin(row,step.to_i)
    when 'x'
      idx = step.split('/',-1)
      row = exchange(row,idx[0].to_i,idx[1].to_i)
    when 'p'
      idx = step.split('/',-1)
      row = partner(row,idx[0],idx[1])
    else
      puts("unrecognised instruction #{move}#{step}")
      exit 1
    end
  end
  return row.join()
end

def spin(row,idx)
  return row.rotate(row.length - idx)
end

def exchange(row,idx1,idx2)
  temp = row[idx1]
  row[idx1] = row[idx2]
  row[idx2] = temp
  return row
end

def partner(row,id1,id2)
  idx = 0
  idx1 = -1
  idx2 = -1
  found = 0
  for dancer in row
    if dancer == id1
      idx1 = idx
      found += 1
    elsif dancer == id2
      idx2 = idx
      found += 1
    end
    if found == 2
      return exchange(row,idx1,idx2)
    end
    idx += 1
  end
  return row
end

puts "Starting Tests:"
tests = Test.new

test_input = Read::string("input_test.txt")
test_steps = test_input.split(',',-1)
tests.test("test spin", 'cdeab', dance('abcde',['s3']))
tests.test("test exchange", 'abedc', dance('abcde',['x2/4']))
tests.test("test partner", 'adcbe', dance('abcde',['pb/d']))

tests.test("test dance", 'baedc', dance('abcde',test_steps))
tests.bail_on_fail

puts "All tests passed!\n---"

input = Read::string("input_data.txt")
steps = input.split(',',-1)
puts("Dance has #{steps.length} steps")
num_dances = 0
total_dances = 1000000000
lineup = 'abcdefghijklmnop'
while num_dances < total_dances
  lineup = dance(lineup, steps)
  num_dances += 1
  if num_dances == 1 || num_dances%1000 == 0
    puts("lineup after #{num_dances} dances: #{lineup}")
  end
end
