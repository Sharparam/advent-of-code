#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

CANDIDATES = {
  Vector[0, 1] => [Vector[1, 0], Vector[-1, 0]],
  Vector[0, -1] => [Vector[1, 0], Vector[-1, 0]],
  Vector[1, 0] => [Vector[0, 1], Vector[0, -1]],
  Vector[-1, 0] => [Vector[0, 1], Vector[0, -1]]
}.freeze

def next_direction(grid, pos, direction)
  x, y = pos[0], pos[1]
  CANDIDATES[direction].find do |c|
    new_x, new_y = x + c[0], y + c[1]
    return false if x < 0 || x >= grid[0].size || y < 0 || y > grid.size
    grid[new_y][new_x] != ' '
  end
end

grid = ARGF.readlines.map { |l| l.chomp.chars }

position = Vector[grid[0].index('|'), 0]
direction = Vector[0, 1]
letters = []
steps = 0

loop do
  x, y = position[0], position[1]
  cell = grid[position[1]][position[0]]

  break if cell == ' '

  steps += 1

  letters << cell if cell =~ /[A-Za-z]/

  direction = next_direction(grid, position, direction) if grid[y][x] == '+'

  break if direction.nil?

  position += direction
end

puts letters.join
puts steps
