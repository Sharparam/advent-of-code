#!/usr/bin/env ruby

require 'matrix'
require 'pp'

require_relative 'exts'

NEIGHBOUR_DIFFS = [-1, 0, 1].repeated_permutation(4).reject { |d| d.all?(&:zero?) }.map { |d| Vector[*d] }.to_a.freeze

grid = Hash[ARGF.readlines.map(&:chomp).flat_map.with_index do |line, y|
  line.split('').map.with_index { |cell, x| [Vector[x, y, 0, 0], cell == ?#] }
end]

grid.default_proc = -> (h, k) { h[k] = false }

x_min, x_max = grid.keys.map(&:x).minmax
y_min, y_max = grid.keys.map(&:y).minmax
z_min, z_max = grid.keys.map(&:z).minmax
w_min, w_max = grid.keys.map(&:w).minmax

(x_min-1..x_max+1).each do |x|
  (y_min-1..y_max+1).each do |y|
    (z_min-1..z_max+1).each do |z|
      (w_min-1..w_max+1).each do |w|
        grid[Vector[x, y, z, w]] # touch
      end
    end
  end
end

step = -> {
  copy = grid.dup

  grid.keys.each do |pos|
    neighbours = pos.neighbours
    active_count = neighbours.count { |n| grid[n] }
    if grid[pos]
      copy[pos] = active_count == 2 || active_count == 3
    else
      copy[pos] = active_count == 3
    end
  end

  grid.merge! copy
}

6.times { step[] }

puts grid.count { _2 }
