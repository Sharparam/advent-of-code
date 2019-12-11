#!/usr/bin/env ruby

require_relative '../intcode/cpu'

require 'set'
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
}

def run(start_color)
  colors = {
    Vector[0, 0] => start_color
  }

  cpu = Intcode::CPU.new.load!(PATH).print_output!(false)

  pos = Vector[0, 0]
  vel = Vector[0, 0]

  while !cpu.halted?
    cpu.input!(colors[pos])
    cpu.run!
    color = cpu.output[-2]
    dir = cpu.output[-1]
    colors[pos] = color
    vel = DIRS[dir][vel]
    pos += vel
  end

  #puts "Part 1: #{colors.size}"

  colors
end

puts "Part 1: #{run(BLACK).size}"

colors = run WHITE

min_x = colors.keys.min_by { |p| p.x }.x
max_x = colors.keys.max_by { |p| p.x }.x
min_y = colors.keys.min_by { |p| p.y }.y
max_y = colors.keys.max_by { |p| p.y }.y

puts "Grid for part 2 goes from (#{min_x}, #{min_y}) to (#{max_x}, #{max_y})"

puts "Part 2:"
(min_y..max_y).each do |y|
  (min_x..max_x).each do |x|
    print colors[Vector[x, y]] == WHITE ? '#' : '.'
  end
  puts
end
