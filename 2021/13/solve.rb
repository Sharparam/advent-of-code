#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Vector
  def x = self[0]
  def x=(v)
    self[0] = v
  end
  def y = self[1]
  def y=(v)
    self[1] = v
  end
end

input, instructions = ARGF.read.split("\n\n")
grid = Hash[input.lines.map { |l| [Vector[*l.split(',').map(&:to_i)], true] }]
instructions = instructions.scan(/(x|y)=(\d+)/).map { |a, n| [a.to_sym, n.to_i] }

def vis(grid)
  max_x = grid.keys.map(&:x).max
  max_y = grid.keys.map(&:y).max
  (0..max_y).each do |y|
    (0..max_x).each do |x|
      print(grid[Vector[x, y]] ? '##' : '..')
    end
    puts
  end
end

def fold(grid, axis, pos)
  Hash[grid.keys.map do |key|
    new_key = key.dup
    new_key.send("#{axis}=", pos - (key.send(axis) - pos).abs)
    [new_key, true]
  end]
end

puts fold(grid, *instructions[0]).size
vis(instructions.reduce(grid) { |a, e| fold(a, *e) })
