#!/usr/bin/env ruby
# frozen_string_literal: true

positions = ARGF.read.split(',').map(&:to_i)
min, max = positions.minmax

puts (min..max).map { |pos| positions.sum { |p| (p - pos).abs } }.min
puts (min..max).map { |pos| positions.sum { |p| ((p - pos).abs).downto(1).sum } }.min
