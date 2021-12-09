#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

map = Hash.new(10)
ARGF.readlines.each_with_index do |line, row|
  line.strip().split('').map(&:to_i).each_with_index do |num, col|
    map[[col, row]] = num
  end
end

def around(pos)
  [
    [pos[0], pos[1] - 1],
    [pos[0], pos[1] + 1],
    [pos[0] - 1, pos[1]],
    [pos[0] + 1, pos[1]]
  ]
end

lows = map.keys.select { |p| around(p).all? { map[p] < map[_1] } }

puts lows.map { map[_1].succ }.sum

puts lows.map { |start|
  visited = Set.new
  queue = [start]
  while queue.any?
    current = queue.pop
    visited << current
    queue.push *around(current).select { !visited.include?(_1) && map[_1] < 9 }
  end
  visited.size
}.sort.pop(3).reduce(:*)
