#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

input = STDIN.readline.strip.to_i

steps = (Math.sqrt(input).ceil / 2).floor
offset = (input - (2 * steps - 1)**2) % (2 * steps)
steps = steps + (offset - steps).abs

puts "Part 1: #{steps}"

# Part 2 from OEIS: https://oeis.org/A141481
