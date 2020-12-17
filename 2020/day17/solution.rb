#!/usr/bin/env ruby

require 'matrix'
require 'pp'

require_relative 'exts'

NEIGHBOUR_DIFFS = [-1, 0, 1].repeated_permutation(3).reject { |d| d.all?(&:zero?) }.map { |d| Vector[*d] }.to_a.freeze

def render(grid)
  x_min, x_max = grid.keys.map(&:x).minmax
  y_min, y_max = grid.keys.map(&:y).minmax
  z_min, z_max = grid.keys.map(&:z).minmax
  width = x_max - x_min + 1
  puts '-' * width
  puts "X: #{x_min}..#{x_max} Y: #{y_min}..#{y_max}"
  (z_min..z_max).each do |z|
    puts "z=#{z}"
    (y_min..y_max).each do |y|
      (x_min..x_max).each do |x|
        pos = Vector[x, y, z]
        char = grid[pos] ? ?# : ?.
        print char
      end
      puts
    end
  end
  puts '-' * width
end

grid = Hash[ARGF.readlines.map(&:chomp).flat_map.with_index do |line, y|
  line.split('').map.with_index { |cell, x| [Vector[x, y, 0], cell == ?#] }
end]

grid.default_proc = -> (h, k) { h[k] = false }

x_min, x_max = grid.keys.map(&:x).minmax
x_min -= 1
x_max += 1
y_min, y_max = grid.keys.map(&:y).minmax
y_min -= 1
y_max += 1
extra = (x_min..x_max).to_a.product((y_min..y_max).to_a).flat_map {
  [Vector[*_1, -1], Vector[*_1, 0], Vector[*_1, 1]]
}
extra.each { |p| grid[p] }

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
    #puts "#{pos}: #{grid[pos]} -> #{copy[pos]}"
  end

  grid.merge! copy

  #render grid
}

#render grid

6.times { step[] }

puts grid.count { _2 }
