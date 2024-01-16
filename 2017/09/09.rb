require_relative "../lib/advent/read"
require_relative "../lib/advent/test"

def remove_cancelled(stream)
  return stream.gsub(/!./,"")
end

def remove_garbage(stream)
  return stream.gsub(/\<[^>]*\>/,"")
end

def score(stream)
  score = 0
  level = 0
  stream.chars.each do |ch|
    if ch == "{"
      level += 1
      score += level
    elsif ch == "}"
      level -= 1
    end
  end
  score
end

def group_score(stream)
  stream = remove_cancelled(stream)
  stream = remove_garbage(stream)
  return score(stream)
end

test_data = {
  "{}" => 1,
  "{{{}}}" => 6,
  "{{},{}}" => 5,
  "{{{},{},{{}}}}" => 16,
  "{<a>,<a>,<a>,<a>}" => 1,
  "{{<ab>},{<ab>},{<ab>},{<ab>}}" => 9,
  "{{<!!>},{<!!>},{<!!>},{<!!>}}" => 9,
  "{{<a!>},{<a!>},{<a!>},{<ab>}}" => 3,
}

puts "Starting Tests:"
tests = Test.new()
test_data.each do |input, answer|
  tests.test("test data #{input}", answer, group_score(input))
end
tests.bail_on_fail()
puts "All tests passed!\n---"

input = Read::string("input_data.txt")
puts "Solution: #{group_score(input)}"
