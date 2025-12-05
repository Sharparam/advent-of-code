#!/usr/bin/env ruby
# frozen_string_literal: true

ranges, available = ARGF.read.split("\n\n")

ranges = ranges.lines.map { |l| l.split('-').then { (_1.to_i)..(_2.to_i) } }
available = available.lines.map(&:to_i)

puts available.count { |a| ranges.any? { _1.include? a } }

part2 = 0
previous_end = -1

ranges.sort { |a, b| a.first == b.first ? a.last <=> b.last : a.first <=> b.first }.each do |range|
  a, b = range.first, range.last
  next if b <= previous_end
  a = previous_end + 1 if a <= previous_end
  previous_end = b
  next if a > b
  part2 += b - a + 1
end

puts part2
