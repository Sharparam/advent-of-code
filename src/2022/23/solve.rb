#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Vector; def to_s; "(#{self[0]}, #{self[1]})"; end; end

lines = ARGF.readlines.map(&:strip).reverse
grid = lines.flat_map.with_index { |l, y| l.chars.map.with_index.select { _1[0] == ?# }.map { Vector[_1[1], y] } }.to_set

DIR = {
  N: Vector[0, 1], S: Vector[0, -1], W: Vector[-1, 0], E: Vector[1, 0],
  NE: Vector[1, 1], NW: Vector[-1, 1],
  SE: Vector[1, -1], SW: Vector[-1, -1]
}.freeze

CHECKS = [
  [DIR[:N], DIR[:NE], DIR[:NW]],
  [DIR[:S], DIR[:SE], DIR[:SW]],
  [DIR[:W], DIR[:NW], DIR[:SW]],
  [DIR[:E], DIR[:NE], DIR[:SE]]
].freeze

CHECK_DIRS = [
  DIR[:N], DIR[:S], DIR[:W], DIR[:E]
].freeze

NEIGHBORS = DIR.values.freeze

def around(pos)
  NEIGHBORS.map { pos + _1 }
end

def print_grid(grid, header)
  puts "== #{header} =="
  x_min, x_max = grid.map { _1[0] }.minmax
  y_min, y_max = grid.map { _1[1] }.minmax

  y_max.downto(y_min).each do |y|
    (x_min..x_max).each do |x|
      print grid.include?(Vector[x, y]) ? '#' : '.'
    end
    puts
  end

  puts
end

def step(grid, check_offset)
  targets = {}
  target_counts = Hash.new(0)

  grid.each do |elf|
    others = around(elf)
    count = others.count { grid.include? _1 }

    if count != 0
      CHECKS.size.times do |c_n|
        check_i = (check_offset + c_n) % CHECKS.size
        checks = CHECKS[check_i]
        check_pos = checks.map { elf + _1 }
        check_count = check_pos.count { grid.include? _1 }
        if check_count == 0
          check_dir = CHECK_DIRS[check_i]
          new_pos = elf + check_dir
          targets[elf] = new_pos
          target_counts[new_pos] += 1
          break
        end
      end
    end
  end

  moves = 0
  targets.each do |o, n|
    if target_counts[n] == 1
      grid.delete o
      grid.add n
      moves += 1 if o != n
    end
  end

  moves
end

check_offset = 0

10.times do |n|
  step(grid, check_offset)

  check_offset = (check_offset + 1) % CHECKS.size
end

x_min, x_max = grid.map { _1[0] }.minmax
y_min, y_max = grid.map { _1[1] }.minmax

area = (x_max - x_min + 1) * (y_max - y_min + 1)
part1 = area - grid.size

puts part1

n = 10
loop do
  moves = step(grid, check_offset)
  break if moves == 0
  check_offset = (check_offset + 1) % CHECKS.size
  n += 1
end

puts n + 1
