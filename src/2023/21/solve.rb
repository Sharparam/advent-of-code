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
raise 'Input must be square' unless HEIGHT == WIDTH
SIZE = HEIGHT

DIRS = [Vector[1, 0], Vector[-1, 0], Vector[0, 1], Vector[0, -1]].freeze

P2_STEPS = 26_501_365

def reachable(poses)
  poses.flat_map { |pos| DIRS.map { pos + _1 }.reject { |pos|
    GRID[pos[1] % HEIGHT][pos[0] % WIDTH] == '#'
  } }
end

poses = [start]
values = []
n = 0

until values.size == 3
  n += 1
  poses = reachable(poses).uniq
  puts poses.size if n == 64
  values.push poses.size if n == P2_STEPS % SIZE + SIZE * values.size
end

# because magic reasons tells us it's polynomial shitfuckery:
# P(x) = ax² + bx + c
# x here is more like the number of grids we've moved
#
# P(0) = a * 0² + b * 0 + c
#      = c
#
# P(1) = a * 1² + b + c
# P(1) = a + b + c
#    b = P(1) - a - c
#
# P(2) = a * 2² + 2b + c
# P(2) = 4a + 2b + c
#   4a = P(2) - 2b - c
#    a = (P(2) - 2b - c) / 4
#    a = (P(2) - 2 * (P(1) - a - c) - c) / 4
#    a = (P(2) - 2 * P(1) + 2a + 2c - c) / 4
#    a = (P(2) - 2 * P(1) + 2a + c) / 4
#   4a = P(2) - 2 * P(1) + 2a + c
#   2a = P(2) - 2 * P(1) + c
#    a = (P(2) - 2 * P(1) + c) / 2
#
# so because the first three values for P(x) are in `values`:
# c = P(0) = values[0]
# a = (P(2) - 2 * P(1) + c) / 2 = (values[2] - 2 * values[1] + c) / 2
# b = P(1) - a - c = values[1] - a - c

C = values[0]
A = (values[2] - 2 * values[1] + C) / 2
B = values[1] - A - C

# Given that number of steps in part 2 apparently must end on an edge,
# get which grid index we are on I guess?

# Subtract the steps from start to first edge,
# so that when we are there, we are on grid index 0
# i.e. if P2_STEPS would be 65: (65 - 131 / 2) / 131 == 0
# Each amount of SIZE after that is one more grid, so grid index
# is simply remaining steps divided by the SIZE
X = (P2_STEPS - SIZE / 2) / SIZE

# puts "Values: #{values}"
# puts "X = #{X}"
# puts "A = #{A}"
# puts "B = #{B}"
# puts "C = #{C}"

puts A * X**2 + B * X + C

# With this, I'm going to put it officially:
# AoC 2023 day 21 part 2 can suck Santa's lollipop.
