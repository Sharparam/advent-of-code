#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

DIRS = {
  ?< => Vector[-1, 0],
  ?v => Vector[0, 1],
  ?> => Vector[1, 0],
  ?^ => Vector[0, -1]
}.freeze

LEFT = Vector[-1, 0]
DOWN = Vector[0, 1]
RIGHT = Vector[1, 0]
UP = Vector[0, -1]

CELL_MATES = {
  ?. => ?.,
  ?@ => ?.,
  ?# => ?#,
  ?[ => ?]
}.freeze

def display(grid, width, height)
  puts '=' * width
  height.times do |y|
    width.times do |x|
      print ' ' if grid[Vector[x, y]].nil?
      print grid[Vector[x, y]]
    end
    puts
  end
  puts '=' * width
end

map_str, move_str = ARGF.read.split "\n\n"

# START = nil

grid = map_str.lines.flat_map.with_index { |line, y|
  line.chomp.chars.map.with_index { |c, x|
    # START = Vector[x, y] if c == ?@
    # [Vector[x, y], c == ?@ ? ?. : c]
    [Vector[x, y], c]
  }
}.to_h

grid2 = grid.flat_map { |k, v|
  new_k = Vector[k[0] * 2, k[1]]
  first = v == ?O ? ?[ : v
  second = CELL_MATES[first]
  [[new_k, first], [new_k + Vector[1, 0], second]]
}.to_h

WIDTH = grid.keys.map { _1[0] }.max + 1
HEIGHT = grid.keys.map { _1[1] }.max + 1
WIDTH2 = grid2.keys.map { _1[0] }.max + 1
HEIGHT2 = grid2.keys.map { _1[1] }.max + 1

# puts "grid 1 is #{WIDTH} x #{HEIGHT}"
# puts "grid 2 is #{WIDTH2} x #{HEIGHT2}"

# puts grid2[Vector[WIDTH2 - 1, HEIGHT2 - 1]]

# display grid, WIDTH, HEIGHT
# display grid2, WIDTH2, HEIGHT2

START = grid.find { |_, v| v == ?@ }.first
START2 = grid2.find { |_, v| v == ?@ }.first

MOVES = move_str.tr("\n", '').chars.map { DIRS[_1] }

# p grid
# p START
# p MOVES

def move(grid, pos, dir)
  new_pos = pos + dir
  new_cell = grid[new_pos]
  return false if new_cell.nil? || new_cell == ?#
  return false if new_cell != ?. && !move(grid, new_pos, dir)
  grid[new_pos] = grid[pos]
  grid[pos] = ?.
  true
end

def can_move_vertical?(grid, pos, dir)
  cell = grid[pos]
  is_box = cell == ?[ || cell == ?]
  new_pos = pos + dir
  new_cell = grid[new_pos]
  # puts "  checking if #{cell} at #{pos} can move #{dir}"
  return false if new_cell.nil? || new_cell == ?#

  return true if !is_box && new_cell == ?.

  unless is_box
    # we are robot pushing on a box
    new_far_pos = new_cell == ?[ ? new_pos + RIGHT : new_pos + LEFT
    return can_move_vertical?(grid, new_pos, dir) && can_move_vertical?(grid, new_far_pos, dir)
  end

  # puts "    before: pos is #{pos} and cell is #{cell}"
  left_pos = cell == ?[ ? pos : pos + LEFT
  right_pos = left_pos + RIGHT
  new_left_pos = left_pos + dir
  new_right_pos = right_pos + dir

  new_left_cell = grid[new_left_pos]
  new_right_cell = grid[new_right_pos]

  # puts "    current is #{left_pos} #{right_pos} (#{grid[left_pos]} #{grid[right_pos]})"
  # puts "    new     is #{new_left_pos} #{new_right_pos} (#{new_left_cell} #{new_right_cell})"

  return true if new_left_cell == ?. && new_right_cell == ?.
  return false if new_left_cell == ?# || new_right_cell == ?#

  if new_left_cell == ?] && new_right_cell == ?.
    return can_move_vertical?(grid, new_left_pos, dir)
  end

  if new_left_cell == ?. && new_right_cell == ?[
    return can_move_vertical?(grid, new_right_pos, dir)
  end

  if new_left_cell == ?[
    return can_move_vertical?(grid, new_left_pos, dir) # && can_move_vertical?(grid, new_right_pos, dir)
  end

  # at this point we know we have the complex case of a box pushing two other boxes

  can_move_vertical?(grid, new_left_pos, dir) && can_move_vertical?(grid, new_right_pos, dir)
end

def move_horizontal(grid, pos, dir)
  # dir is either Vector[1, 0] or Vector[-1, 0]
  cell = grid[pos]
  is_box_edge = cell == ?[ || cell == ?]
  new_pos = pos + dir
  new_cell = grid[new_pos]
  return false if new_cell.nil? || new_cell == ?#
  new_far_pos = new_pos + dir
  new_far_cell = grid[new_far_pos]
  return false if is_box_edge && (new_far_cell.nil? || new_far_cell == ?#)

  return false if new_cell != ?. && !move(grid, new_pos, dir)

  grid[new_pos] = cell
  grid[pos] = ?.

  true
end

def move_vertical(grid, pos, dir, checked: false)
  # dir is either Vector[0, 1] or Vector[0, -1]
  cell = grid[pos]
  # raise 'trying to move a wall' if cell == ?#
  if cell == ?#
    display grid, WIDTH2, HEIGHT2
    raise "trying to move wall at #{pos} in direction #{dir}"
  end
  raise 'trying to move empty space' if cell == ?.
  is_box = cell == ?[ || cell == ?]
  new_pos = pos + dir
  new_cell = grid[new_pos]
  far_pos = cell == ?[ ? pos + RIGHT : pos + LEFT
  far_cell = grid[far_pos]
  far_new_pos = far_pos + dir
  far_new_cell = grid[far_new_pos]

  return false unless checked || can_move_vertical?(grid, pos, dir)

  if is_box && (new_cell != ?. || far_new_cell != ?.)
    left_pos = cell == ?[ ? pos : pos + LEFT
    right_pos = left_pos + RIGHT
    left_new_pos = left_pos + dir
    right_new_pos = right_pos + dir
    left_new_cell = grid[left_new_pos]
    right_new_cell = grid[right_new_pos]
    if left_new_cell == ?] && right_new_cell == ?[
      raise 'checked left move failed' unless move_vertical(grid, left_new_pos, dir, checked: true)
      raise 'checked right move failed' unless move_vertical(grid, right_new_pos, dir, checked: true)
    elsif left_new_cell == ?.
      raise 'checked move failed' unless move_vertical(grid, right_new_pos, dir, checked: true)
    else
      raise 'checked move failed' unless move_vertical(grid, left_new_pos, dir, checked: true)
    end
  elsif new_cell != ?.
    raise 'checked move failed' unless move_vertical(grid, new_pos, dir, checked: true)
  end

  grid[new_pos] = cell
  grid[pos] = ?.

  return true unless is_box
  grid[far_new_pos] = far_cell
  grid[far_pos] = ?.
  true
end

def move2(grid, pos, dir)
  return move_vertical(grid, pos, dir) if dir == UP || dir == DOWN
  move_horizontal(grid, pos, dir)
end

# display grid

pos = START

MOVES.each do |m|
  pos += m if move(grid, pos, m)
  # display grid
end

puts grid.filter_map { |p, v| v == ?O ? p : nil }.sum { (100 * _1[1]) + _1[0] }

pos2 = START2

# display grid2, WIDTH2, HEIGHT2

MOVES.each do |m|
  # puts "attempting to move #{grid2[pos2]} #{m}"
  pos2 += m if move2(grid2, pos2, m)
  # display grid2, WIDTH2, HEIGHT2
end

puts grid2.filter_map { |p, v| v == ?[ ? p : nil }.sum { (100 * _1[1]) + _1[0] }
