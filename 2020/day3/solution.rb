#!/usr/bin/env ruby

input = ARGF.readlines.map(&:strip)

def count(map, step)
  # x = 0
  # y = 0
  # trees = 0

  map.size.times.sum { |t|
    y = t * step[1]
    map[y]&.[]((t * step[0]) % map[y].size) == ?# ? 1 : 0
  }

  # while y < map.size
  #   x += step[0]
  #   y += step[1]
  #   trees += 1 if map[y]&.[](x % map[y].size) == ?#
  # end

  # trees
end

part1 = count input, [3, 1]
puts part1

rest = [[1, 1], [5, 1], [7, 1], [1, 2]].map { |s| count input, s }

puts (rest + [part1]).reduce(:*)
