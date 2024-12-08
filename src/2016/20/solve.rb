#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

IP_MAX = 4_294_967_295

ranges = STDIN.readlines.map { |line| Range.new(*line.split('-').map(&:to_i)) }

ranges.sort! { |a, b| a.min <=> b.min }

current = 0

min = ranges.first.min
max = ranges.first.max

valid = 0 + min

while r = ranges.shift
  current = r.max + 1 if r === current

  if r.min > max
    valid += r.min - max - 1
    min = r.min
    max = r.max
  end

  if r.max > max
    max = r.max
  end
end

puts "(1) #{current}"
puts "(2) #{valid}"
