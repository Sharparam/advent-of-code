#!/usr/bin/env ruby
# frozen_string_literal: true

A_FACTOR = 16_807
B_FACTOR = 48_271
DIVISOR = 2_147_483_647

A_START, B_START = ARGF.read.scan(/\d+/).map(&:to_i)

a, b = A_START, B_START
matches = 0

40_000_000.times do
  a = (a * A_FACTOR) % DIVISOR
  b = (b * B_FACTOR) % DIVISOR
  matches += 1 if (a & 0xFFFF) == (b & 0xFFFF)
end

puts matches

a, b = A_START, B_START
matches = 0

5_000_000.times do |_i|
  a = (a * A_FACTOR) % DIVISOR
  b = (b * B_FACTOR) % DIVISOR
  a = (a * A_FACTOR) % DIVISOR until a % 4 == 0
  b = (b * B_FACTOR) % DIVISOR until b % 8 == 0
  matches += 1 if (a & 0xFFFF) == (b & 0xFFFF)
end

puts matches
