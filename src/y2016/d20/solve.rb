#!/usr/bin/env ruby
# frozen_string_literal: true

IP_MAX = 4_294_967_295

ranges = $stdin.readlines.map { |line| Range.new(*line.split('-').map(&:to_i)) }

ranges.sort! { |a, b| a.min <=> b.min }

current = 0

min = ranges.first.min
max = ranges.first.max

valid = 0 + min

while (r = ranges.shift)
  current = r.max + 1 if r === current

  if r.min > max
    valid += r.min - max - 1
    _min = r.min
    max = r.max
  end

  max = r.max if r.max > max
end

puts "(1) #{current}"
puts "(2) #{valid}"
