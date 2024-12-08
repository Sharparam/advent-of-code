#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Vector
  def x = self[0]
  def y = self[1]

  def around?(start, stop)
    (x >= start.x - 1 && x <= stop.x + 1) && (y >= start.y - 1 && y <= start.y + 1)
  end

  def to_s = "(#{x}, #{y})"
end

$numbers = []
$num = []
symbols = []

def addnum(startx, stopx, y)
  $numbers << { value: $num.join.to_i, start: Vector[startx, y], stop: Vector[stopx, y] }
  $num = []
end

ARGF.read.lines.each_with_index do |line, row|
  x = 0
  line.chars.each_with_index do |char, col|
    case char
    when '.'
      addnum(x, col - 1, row) if $num.any?
    when /\d/
      x = col if $num.empty?
      $num << char
    else
      addnum(x, col - 1, row) if $num.any?
      symbols << { value: char, pos: Vector[col, row] } unless char == ?\n
    end
  end
end

part1 = 0

$numbers.each do |number|
  part1 += number[:value] if symbols.any? { |symbol| symbol[:pos].around?(number[:start], number[:stop]) }
end

puts part1

gears = symbols.select { |s| s[:value] == '*' }

part2 = 0

gears.each do |gear|
  nums = $numbers.select { |n| gear[:pos].around?(n[:start], n[:stop]) }
  part2 += nums[0][:value] * nums[1][:value] if nums.size == 2
end

puts part2
