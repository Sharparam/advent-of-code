#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'

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
grid = input.lines.map { Vector[*_1.split(',').map(&:to_i)] }.to_set
instructions = instructions.scan(/(x|y)=(\d+)/).map { |a, n| [a.to_sym, n.to_i] }

def vis(grid)
  max_x = grid.map(&:x).max
  max_y = grid.map(&:y).max
  puts (0..max_y).map { |y| (0..max_x).map { grid.include?(Vector[_1, y]) ? '##' : '..' }.join }
end

def fold(grid, axis, pos)
  grid.map { |k| k.dup.tap { _1.send("#{axis}=", pos - (k.send(axis) - pos).abs) } }.to_set
end

puts fold(grid, *instructions[0]).size
vis(instructions.reduce(grid) { |a, e| fold(a, *e) })
