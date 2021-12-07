#!/usr/bin/env ruby
# frozen_string_literal: true

positions = ARGF.read.split(',').map(&:to_i)
min, max = positions.minmax
costs = (1..(max - min + 1)).inject([0]) { _1 << _1.last + _2 }

puts (min..max).map { |pos| positions.sum { |p| (p - pos).abs } }.min
puts (min..max).map { |pos| positions.sum { |p| costs[(p - pos).abs] } }.min
