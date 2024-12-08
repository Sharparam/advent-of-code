#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

NEIGHBOUR_DIFFS = Hash[
  [3, 4].map { |s| [s, [-1, 0, 1].repeated_permutation(s).reject { _1.all?(&:zero?) }.map { Vector[*_1] }.to_a] }
]

class Vector
  def neighbours
    NEIGHBOUR_DIFFS[size].map { self + _1 }
  end
end

def count_adjacents(grid, pos)
  neighbours = pos.neighbours
  neighbours.count { grid.include? _1 }
end

def step(grid)
  counts = grid.flat_map do |pos|
    [pos, *pos.neighbours.reject { grid.include? _1 }].map do
      [_1, grid.include?(_1), count_adjacents(grid, _1)]
    end
  end

  counts.each do |pos, active, count|
    if active
      grid.delete pos unless count == 2 || count == 3
    elsif count == 3
      grid.add pos
    end
  end
end

LINES = ARGF.readlines.map(&:chomp)

grids = [->(x, y) { Vector[x, y, 0] }, ->(x, y) { Vector[x, y, 0, 0] }].map do |f|
  LINES.flat_map.with_index do |line, y|
    line.split('').map.with_index { |v, x| [f[x, y], v == ?#] }
  end.select { _2 }.map(&:first).to_set
end

grids.each do |grid|
  6.times { step grid }
  puts grid.size
end
