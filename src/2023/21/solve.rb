#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

start = nil

GRID = ARGF.readlines(chomp: true).map.with_index do |line, y|
  line.chars.each_with_index do |char, x|
     start = Vector[x, y] if char == ?S
  end
end

HEIGHT = GRID.size
WIDTH = GRID[0].size

DIRS = [Vector[1, 0], Vector[-1, 0], Vector[0, 1], Vector[0, -1]]

def reachable(poses)
  poses.flat_map { |pos| DIRS.map { pos + _1 }.reject { |pos|
    pos[0] < 0 || pos[0] >= WIDTH || pos[1] < 0 || pos[1] >= HEIGHT || GRID[pos[1]][pos[0]] == '#'
    # GRID[pos[1] % HEIGHT][pos[0] % WIDTH] == '#' # part 2
  } }
end

poses = [start]

64.times do
  poses = reachable(poses).uniq
end

puts poses.size
