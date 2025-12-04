#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

grid = ARGF.flat_map.with_index { |line, y|
  line.chomp.chars.map.with_index { |char, x|
    next if char == '.'
    Vector[x, y]
  }.compact
}.to_set

width = grid.map { _1[0] }.max + 1
height = grid.map { _1[1] }.max + 1

AROUND = [
  Vector[-1, -1], Vector[0, -1], Vector[1, -1],
  Vector[-1, 0], Vector[1, 0],
  Vector[-1, 1], Vector[0, 1], Vector[1, 1]
]

def adj(pos)
  AROUND.map { pos + _1 }
end

puts grid.count { |pos|
  adj(pos).count { grid.include? _1 } < 4
}
