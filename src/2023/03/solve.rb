#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'

class Vector
  def x = self[0]
  def y = self[1]

  def around?(start, stop)
    (self.x >= start.x - 1 && self.x <= stop.x + 1) && (self.y >= start.y - 1 && self.y <= start.y + 1)
  end

  def to_s = "(#{x}, #{y})"
end

numbers = []
symbols = []

id = 0
ARGF.read.lines.each_with_index do |line, row|
  num = []
  x = 0
  line.chomp.chars.each_with_index do |char, col|
    case char
    when '.'
      if num.any?
        number = num.join.to_i
        num = []
        start = Vector[x, row]
        stop = Vector[col - 1, row]
        numbers << { id: id += 1, value: number, start: start, stop: stop }
      end
    when /\d/
      x = col if num.empty?
      num << char
    else
      if num.any?
        number = num.join.to_i
        num = []
        start = Vector[x, row]
        stop = Vector[col - 1, row]
        numbers << { id: id += 1, value: number, start: start, stop: stop }
      end
      symbols << { value: char, pos: Vector[col, row] }
    end
  end
  if num.any?
    number = num.join.to_i
    start = Vector[x, row]
    stop = Vector[line.chomp.size - 1, row]
    numbers << { id: id += 1, value: number, start: start, stop: stop }
  end
end

puts "Total sum: #{numbers.sum { |n| n[:value] }}"

part1 = 0

seen = Set.new
numbers.each do |number|
  if !seen.include?(number[:id]) && symbols.any? { |symbol| symbol[:pos].around?(number[:start], number[:stop]) }
    part1 += number[:value]
    seen.add number[:id]
  end
end

puts part1

gears = symbols.select { |s| s[:value] == '*' }

part2 = 0

gears.each do |gear|
  nums = numbers.select { |n| gear[:pos].around?(n[:start], n[:stop]) }
  if nums.size == 2
    part2 += nums.reduce(1) { |a, e| a * e[:value] }
  end
end

puts part2
