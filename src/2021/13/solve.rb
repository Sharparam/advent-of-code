#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

input, instructions = ARGF.read.split("\n\n")
grid = input.scan(/\d+/).map(&:to_i).each_slice(2).to_set
instructions = instructions.scan(/(x|y)=(\d+)/).map { [_1 == 'x' ? 0 : 1, _2.to_i] }

def vis(grid)
  max_x = grid.map(&:first).max
  max_y = grid.map { _1[1] }.max
  puts (0..max_y).map { |y| (0..max_x).map { grid.include?([_1, y]) ? '██' : '  ' }.join }
end

def fold(grid, axis, pos)
  grid.map { |k| k.dup.tap { _1[axis] = pos - (k[axis] - pos).abs } }.to_set
end

puts fold(grid, *instructions[0]).size
vis(instructions.reduce(grid) { |a, e| fold(a, *e) })
