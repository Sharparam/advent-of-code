#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/aoc/intcode/cpu'

require 'matrix'

class Vector
  def x; self[0]; end
  def y; self[1]; end
end

PATH = ARGV.first || 'input'

BLACK = 0
WHITE = 1
LEFT = 0
RIGHT = 1

DIRS = {
  LEFT => {
    Vector[0, 0] => Vector[-1, 0],
    Vector[1, 0] => Vector[0, -1],
    Vector[0, 1] => Vector[1, 0],
    Vector[-1, 0] => Vector[0, 1],
    Vector[0, -1] => Vector[-1, 0]
  },
  RIGHT => {
    Vector[0, 0] => Vector[1, 0],
    Vector[1, 0] => Vector[0, 1],
    Vector[0, 1] => Vector[-1, 0],
    Vector[-1, 0] => Vector[0, -1],
    Vector[0, -1] => Vector[1, 0]
  }
}.freeze

def run(_start_c)
  colors = {
    Vector[0, 0] => start_color
  }

  cpu = AoC::Intcode::CPU.new.load!(PATH).print_output!(false)

  pos = Vector[0, 0]
  vel = Vector[0, 0]

  until cpu.halted?
    cpu.input!(colors[pos])
    cpu.run!
    c = cpu.output[-2]
    dir = cpu.output[-1]
    colors[pos] = c
    vel = DIRS[dir][vel]
    pos += vel
  end

  colors
end

puts "Part 1: #{run(BLACK).size}"

colors = run WHITE

min_x = colors.keys.min_by(&:x).x
max_x = colors.keys.max_by(&:x).x
min_y = colors.keys.min_by(&:y).y
max_y = colors.keys.max_by(&:y).y

puts "Grid for part 2 goes from (#{min_x}, #{min_y}) to (#{max_x}, #{max_y})"

puts 'Part 2:'
(min_y..max_y).each do |y|
  (min_x..max_x).each do |x|
    print colors[Vector[x, y]] == WHITE ? '██' : '  '
  end
  puts
end
