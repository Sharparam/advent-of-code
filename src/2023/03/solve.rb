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
        num.clear
        start = Vector[x, row]
        stop = Vector[col - 1, row]
        numbers << { id: id += 1, value: number, start: start, stop: stop }
      end
    when /\d/
      x = col if num.empty?
      num << char
    else
      symbols << Vector[col, row]
    end
  end
  if num.any?
    number = num.join.to_i
    start = Vector[x, row]
    stop = Vector[line.chomp.size - 1, row]
    numbers << { id: id += 1, value: number, start: start, stop: stop }
  end
end

part1 = 0

seen = Set.new
numbers.each do |number|
  if !seen.include?(number[:id]) && symbols.any? { |symbol| symbol.around?(number[:start], number[:stop]) }
    # puts "Adding #{number}"
    part1 += number[:value]
    seen.add number[:id]
  end
end

puts part1
