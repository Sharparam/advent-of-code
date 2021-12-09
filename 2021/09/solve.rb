#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'

map = Hash.new(10)
ARGF.readlines.each_with_index do |line, row|
  line.strip().split('').map(&:to_i).each_with_index do |num, col|
    map[Vector[col, row]] = num
  end
end

def around(pos)
  [
    Vector[pos[0], pos[1] - 1],
    Vector[pos[0], pos[1] + 1],
    Vector[pos[0] - 1, pos[1]],
    Vector[pos[0] + 1, pos[1]]
  ]
end

puts map.select { |pos, num| around(pos).all? { |p| map[p] > num }}.map { |_, n| n.succ }.sum

basins = []
visited = Set.new
width = map.keys.map { _1[0] }.max + 1
height = map.keys.map { _1[1] }.max + 1

while visited.size < map.keys.size
  current = map.keys.find { !visited.include? _1 }
  visited << current
  next if map[current] >= 9
  size = 1
  queue = around(current).select { !visited.include? _1 }
  queue.reject! { _1[0] < 0 || _1[0] >= width || _1[1] < 0 || _1[1] >= height }
  while queue.any?
    current = queue.pop
    next if visited.include? current
    visited << current
    next if map[current] >= 9
    size += 1
    queue.push *around(current).select { !visited.include? _1 }
    queue.reject! { _1[0] < 0 || _1[0] >= width || _1[1] < 0 || _1[1] >= height }
  end
  basins << size
end

puts basins.sort.pop(3).reduce(:*)
