#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.readlines.map(&:strip)

def count(map, step)
  map.size.times.sum { |t|
    y = t * step[1]
    map[y]&.[]((t * step[0]) % map[y].size) == ?# ? 1 : 0
  }
end

part1 = count input, [3, 1]
puts part1

rest = [[1, 1], [5, 1], [7, 1], [1, 2]].map { |s| count input, s }

puts (rest + [part1]).reduce(:*)
