#!/usr/bin/env ruby
# frozen_string_literal: true

RANGES = Hash[ARGF.readlines.map { |l| l.split.map(&:to_i) }]
MAX_DEPTH = RANGES.keys.max

def walk(delay)
  severity = 0
  caught = false

  (0..MAX_DEPTH).each do |depth|
    range = RANGES[depth]
    next if range.nil? || (depth + delay) % (range * 2 - 2) != 0
    severity += depth * range
    caught = true
  end

  [caught, severity]
end

_, s = walk(0)
puts s

puts (10..).find { |d| !walk(d)[0] }
