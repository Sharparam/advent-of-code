#!/usr/bin/env ruby
# frozen_string_literal: true

lines = ARGF.readlines.map(&:chomp)

WIDTH = lines.map(&:size).max
HEIGHT = lines.size

problems = lines.map { |line|
  line.split.map { |w| w =~ /^\d+$/ ? w.to_i : w.to_sym }
}.transpose

puts problems.sum { |p| p[...-1].reduce(p[-1]) }

part2 = 0
op = nil
num = 0
nums = []

WIDTH.times do |col|
  HEIGHT.times do |row|
    c = lines[row][col]
    if c =~ /\d/
      num = (num * 10) + c.to_i
      next
    end

    if c == ?+ || c == ?*
      if nums.any?
        part2 += nums.reduce(op)
        nums = []
      end

      op = c.to_sym
    end

    if row == HEIGHT - 1
      nums.push num unless num.zero?
      num = 0
    end
  end
end

part2 += nums.reduce(op)

puts part2
