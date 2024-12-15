#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

DIRS = {
  ?< => Vector[-1, 0],
  ?v => Vector[0, 1],
  ?> => Vector[1, 0],
  ?^ => Vector[0, -1]
}.freeze

map_str, move_str = ARGF.read.split "\n\n"

# START = nil

GRID = map_str.lines.flat_map.with_index { |line, y|
  line.chomp.chars.map.with_index { |c, x|
    # START = Vector[x, y] if c == ?@
    # [Vector[x, y], c == ?@ ? ?. : c]
    [Vector[x, y], c]
  }
}.to_h

WIDTH = GRID.keys.map { _1[0] }.max + 1
HEIGHT = GRID.keys.map { _1[1] }.max + 1

START = GRID.find { |_, v| v == ?@ }.first

MOVES = move_str.tr("\n", '').chars.map { DIRS[_1] }

# p GRID
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

def display(grid)
  puts '=' * WIDTH
  HEIGHT.times do |y|
    WIDTH.times do |x|
      print grid[Vector[x, y]]
    end
    puts
  end
  puts '=' * WIDTH
end

# display GRID

pos = START

MOVES.each do |move|
  pos += move if move(GRID, pos, move)
  # display GRID
end

puts GRID.filter_map { |p, v| v == ?O ? p : nil }.sum { (100 * _1[1]) + _1[0] }
