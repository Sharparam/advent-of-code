#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'

class Vector
  def x = self[0]
  def y = self[1]
end

grid = {}

ARGF.readlines.map(&:strip).each_with_index do |line, row|
  line.chars.map(&:to_i).each_with_index do |char, col|
    grid[Vector[col, row]] = char
  end
end

def adj(pos)
  [
    Vector[pos.x - 1, pos.y - 1], Vector[pos.x, pos.y - 1], Vector[pos.x + 1, pos.y - 1],
    Vector[pos.x - 1, pos.y], Vector[pos.x + 1, pos.y],
    Vector[pos.x - 1, pos.y + 1], Vector[pos.x, pos.y + 1], Vector[pos.x + 1, pos.y + 1]
  ]
end

flashed = Set.new
flash_count = 0

(1..).each do |n|
  grid.keys.each { |p| grid[p] += 1 }
  flash_poses = grid.select { |_, v| v > 9 }.map(&:first)
  flashed.merge flash_poses
  process = flash_poses.flat_map { |p| adj(p).select { grid.key?(_1) && !flashed.include?(_1) } }
  while process.any?
    pos = process.pop
    grid[pos] += 1
    if grid[pos] > 9
      process.delete pos
      new_adj = adj(pos).select { |p| grid.key?(p) && !flashed.include?(p) }
      process.push *new_adj
      flashed.add pos
    end
  end
  flashed.each { |p| grid[p] = 0 }
  flash_count += flashed.size
  flashed.clear
  puts flash_count if n == 100
  break puts n if grid.values.all?(&:zero?)
end
