#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

grid = ARGF.flat_map.with_index { |line, y|
  line.chomp.chars.map.with_index { |char, x|
    next if char == '.'
    Vector[x, y]
  }.compact
}.to_set

WIDTH = grid.map { _1[0] }.max + 1
HEIGHT = grid.map { _1[1] }.max + 1

AROUND = [
  Vector[-1, -1], Vector[0, -1], Vector[1, -1],
  Vector[-1, 0], Vector[1, 0],
  Vector[-1, 1], Vector[0, 1], Vector[1, 1]
].freeze

def adj(pos)
  AROUND.map { pos + _1 }.reject {
    _1[0] < 0 || _1[0] >= WIDTH || _1[1] < 0 || _1[1] >= HEIGHT
  }
end

puts grid.count { |pos|
  adj(pos).count { grid.include? _1 } < 4
}

part2 = 0
check = grid.to_a

until check.empty?
  new_check = []
  new_grid = grid.dup
  removed = 0
  check.each do |pos|
    next unless grid.include?(pos)
    a = adj(pos).select { grid.include?(_1) }
    pass = a.size < 4
    next unless pass
    new_grid.delete pos
    removed += 1
    new_check.concat a
  end
  check = new_check.uniq
  grid = new_grid
  part2 += removed
end

puts part2
