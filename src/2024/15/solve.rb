#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'aoc/point'

P = AoC::Point2

LEFT = P[-1, 0]
DOWN = P[0, 1]
RIGHT = P[1, 0]
UP = P[0, -1]

DIRS = {
  ?< => LEFT,
  ?v => DOWN,
  ?> => RIGHT,
  ?^ => UP
}.freeze

CELL_MATES = {
  ?. => ?.,
  ?@ => ?.,
  ?# => ?#,
  ?[ => ?]
}.freeze

def display(grid)
  $width ||= grid.keys.map(&:x).max + 1
  $height ||= grid.keys.map(&:y).max + 1
  puts '=' * $width
  $height.times do |y|
    $width.times do |x|
      print ' ' if grid[P[x, y]].nil?
      print grid[P[x, y]]
    end
    puts
  end
  puts '=' * $width
end

map_str, move_str = ARGF.read.split "\n\n"

grid = map_str.lines.flat_map.with_index { |line, y|
  line.chomp.chars.map.with_index { |c, x|
    [P[x, y], c]
  }
}.to_h

grid2 = grid.flat_map { |k, v|
  new_k = P[k.x * 2, k.y]
  cell = v == ?O ? ?[ : v
  [[new_k, cell], [new_k + P[1, 0], CELL_MATES[cell]]]
}.to_h

START = grid.find { |_, v| v == ?@ }.first
START2 = grid2.find { |_, v| v == ?@ }.first

MOVES = move_str.tr("\n", '').chars.map { DIRS[_1] }

def move(grid, pos, dir)
  new_pos = pos + dir
  new_cell = grid[new_pos]
  return pos if new_cell.nil? || new_cell == ?#
  move(grid, new_pos, dir) if new_cell != ?.
  return pos unless grid[new_pos] == ?.
  grid[new_pos] = grid[pos]
  grid[pos] = ?.
  new_pos
end

BOX_CELLS = Set.new %w[[ ]]

def move_vertical(grid, poses, dir)
  new_poses = poses.map { _1 + dir }
  return poses if new_poses.any? { grid[_1].nil? || grid[_1] == ?# }
  if new_poses.any? { BOX_CELLS.include?(grid[_1]) }
    poses_to_move = Set.new
    new_poses.each do |new_pos|
      if grid[new_pos] == ?[
        poses_to_move.add new_pos
        poses_to_move.add new_pos + RIGHT
      elsif grid[new_pos] == ?]
        poses_to_move.add new_pos
        poses_to_move.add new_pos + LEFT
      end
    end
    move_vertical grid, poses_to_move, dir
  end

  return poses unless new_poses.all? { grid[_1] == ?. }

  poses.zip(new_poses).each do |pos, new_pos|
    grid[new_pos] = grid[pos]
    grid[pos] = ?.
  end
  new_poses
end

def move2(grid, pos, dir)
  return move_vertical(grid, [pos], dir)[0] if dir.x.zero?
  move(grid, pos, dir)
end

pos = START
pos2 = START2

MOVES.each do |m|
  pos = move(grid, pos, m)
  pos2 = move2(grid2, pos2, m)
end

puts grid.filter_map { |p, v| v == ?O ? p : nil }.sum { (100 * _1.y) + _1.x }
puts grid2.filter_map { |p, v| v == ?[ ? p : nil }.sum { (100 * _1.y) + _1.x }
