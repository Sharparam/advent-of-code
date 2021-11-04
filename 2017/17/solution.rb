#!/usr/bin/env ruby
# frozen_string_literal: true

STEPS = ARGV[0]&.to_i || 303

buffer = [0]
idx = 0

(1..2017).each do |n|
  idx = ((idx + STEPS) % buffer.size) + 1
  buffer.insert idx, n
end

puts buffer[(idx + 1) % buffer.size]

part2 = buffer[1]

(2018..50_000_000).each do |n|
  idx = ((idx + STEPS) % n) + 1
  part2 = n if idx == 1
end

puts part2
