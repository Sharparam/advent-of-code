#!/usr/bin/env ruby

input = ARGF.readlines.map(&:to_i)

puts input.combination(2).find { |p| p.sum == 2020 }.reduce(:*)
puts input.combination(3).find { |t| t.sum == 2020 }.reduce(:*)
