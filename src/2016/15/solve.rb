#!/usr/bin/env ruby
# frozen_string_literal: true

require 'ostruct'

discs = $stdin.readlines.map do |line|
  size, start = line.strip.match(/(\d+) positions.+?position (\d+)/).to_a[1..2].map(&:to_i)
  OpenStruct.new size: size, position: start
end

def test?(discs, start)
  discs.all? { |disc| (disc.position + (start += 1)) % disc.size == 0 }
end

start = -1

loop until test? discs, (start += 1)

puts "(1) #{start}"

start = -1

discs.push OpenStruct.new size: 11, position: 0

loop until test? discs, (start += 1)

puts "(2) #{start}"
