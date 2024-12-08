#!/usr/bin/env ruby
# frozen_string_literal: true

CHAR_MAP = {
  '.' => :open,
  '|' => :wooded,
  '#' => :lumberyard
}.freeze

DISPLAY_MAP = {
  open: '.',
  wooded: '|',
  lumberyard: '#'
}.freeze

width = 0
height = 0

# grid[y][x]
grid = []

File.readlines('input.txt').map(&:strip).each do |line|
  width = line.size
  cells = line.chars.map { |c| CHAR_MAP[c] }
  grid << cells
  height += 1
end

def display(grid)
  grid.each do |line|
    line.each { |c| print DISPLAY_MAP[c] }
    puts
  end
end

def new_type(grid, x, y)
  current = grid[y][x]
  surrounding = []
  ((x - 1..x + 1).to_a.product((y - 1..y + 1).to_a) - [[x, y]]).each do |(sx, sy)|
    next if sx < 0 || sx >= grid[y].size || sy < 0 || sy >= grid.size
    surrounding << grid[sy][sx]
  end

  return :wooded if current == :open && surrounding.count(:wooded) >= 3
  return :lumberyard if current == :wooded && surrounding.count(:lumberyard) >= 3
  return :open if current == :lumberyard && (surrounding.count(:lumberyard) < 1 || surrounding.count(:wooded) < 1)

  current
end

def transform(grid)
  grid.map.with_index do |line, y|
    line.map.with_index { |cell, x| new_type grid, x, y }
  end
end

def resource_value(grid)
  wooded = grid.reduce(0) { |a, e| a + e.count(:wooded) }
  lumberyards = grid.reduce(0) { |a, e| a + e.count(:lumberyard) }
  wooded * lumberyards
end

count = ARGV.first&.to_i || 10

count.times do |m|
  grid = transform grid
  puts resource_value grid
end

puts "Part 1: #{resource_value grid}"

# Part 2 takes too long to solve with my code, BUT!
# At some point, the resource value starts to repeat
# For my input, repetition starts at minute 465,
# where the same 28 numbers will repeat endlessly (as far as I can tell)
#
# So then, we can devise an algorithm to calculate the resource value for any minute >= 465:
#
# Let M = 465 be the minute where repetition starts, and nums = [...] be the array that contains
# the 28 repeating numbers in order (starting with the first repeating number at minute 465 and
# ending with the last repeating number at minute 492).
# Let len be the length of nums
# Let min be the requested minute (1000000000 in part 2)
#
# resource_value = nums[(min - 465) % len]
#
# For part 2 with my input, the answer is 200364
