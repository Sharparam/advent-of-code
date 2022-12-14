#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'

cave = {}

ARGF.readlines.map { |l| l.split(' -> ').map { Vector[*_1.split(',').map(&:to_i)] } }.each do |coords|
  coords.each_cons(2) do |a, b|
    x1, y1, x2, y2 = a[0], a[1], b[0], b[1]
    if (x1 <=> x2) != 0
      ([x1, x2].min..[x1, x2].max).each { cave[Vector[_1, y1]] = :rock }
    else
      ([y1, y2].min..[y1, y2].max).each { cave[Vector[x1, _1]] = :rock }
    end
  end
end

Y_MAX = cave.keys.map { _1[1] }.max
Y_MAX_2 = Y_MAX + 2

part_1 = false

loop do
  pos = Vector[500, 0]

  loop do
    new_pos = [Vector[pos[0], pos[1] + 1], Vector[pos[0] - 1, pos[1] + 1], Vector[pos[0] + 1, pos[1] + 1]].find { !cave.key?(_1) && _1[1] < Y_MAX_2 }

    if new_pos.nil?
      cave[pos] = :sand
      break
    end

    pos = new_pos

    if pos[1] > Y_MAX && !part_1
      puts cave.values.count(:sand)
      part_1 = true
    end
  end

  break if cave.key?(Vector[500, 0])
end

puts cave.values.count(:sand)
