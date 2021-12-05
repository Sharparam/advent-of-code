#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

lines = ARGF.readlines.map { |l| l.split(' -> ').map { |c| Vector[*c.split(',').map(&:to_i)] } }

def line_coords(a, b)
  ax, bx = a[0], b[0]
  ay, by = a[1], b[1]
  xs = ax < bx ? (ax..bx).to_a : (ax.downto bx).to_a
  ys = ay < by ? (ay..by).to_a : (ay.downto by).to_a

  return (xs.zip ys).map { Vector[*_1] } if xs.size == ys.size
  return ys.map { |y| Vector[xs[0], y] } if xs.size == 1
  xs.map { |x| Vector[x, ys[0]] }
end

horiz_lines = lines.select { _1[0] == _2[0] || _1[1] == _2[1] }

puts horiz_lines.flat_map { line_coords *_1 }.tally.count { _2 > 1 }
puts lines.flat_map { line_coords *_1 }.tally.count { _2 > 1 }

