#!/usr/bin/env ruby
# frozen_string_literal: true

input = $stdin.each_line.map { |l| l.split.map(&:to_i) }
part1 = input.reduce(0) { |a, e| a + e.max - e.min }
part2 = input.reduce(0) { |a, e| a + e.permutation(2).find { |p| p.reduce(&:%) == 0 }.reduce(&:/) }

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
