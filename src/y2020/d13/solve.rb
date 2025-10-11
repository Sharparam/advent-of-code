#!/usr/bin/env ruby
# frozen_string_literal: true

EARLIEST = ARGF.readline.to_i
SCHEDULE = ARGF.readline.split(?,).map(&:to_i)
IDS = SCHEDULE.reject(&:zero?)

def solve(id)
  current = 0
  current += id while current < EARLIEST
  current
end

puts IDS.map { [_1, solve(_1)] }.min_by { _2 }.then { _1 * (_2 - EARLIEST) }

OFFSETS = SCHEDULE.map.with_index { [_1.to_i, _2] }.reject { _1[0].zero? }.to_h

def solve2
  current = 0

  loop do
    valid = OFFSETS.select { |id, offset| (current + offset) % id == 0 }
    return current if valid.size == OFFSETS.size
    current += valid.map(&:first).reduce(:lcm) || 1
  end
end

puts solve2

# VERIFY solve2:
# require_relative '../utils'
# p Utils.crt(OFFSETS.keys, OFFSETS.map { -_2 % _1 })
