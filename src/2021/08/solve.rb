#!/usr/bin/env ruby
# frozen_string_literal: true

data = ARGF.readlines.map do |line|
  patterns, output = line.split(' | ').map(&:split)
  { patterns: patterns.map { _1.chars.sort.join }, output: output.map { _1.chars.sort.join } }
end

UNIQUE_SEGMENTS = Set[2, 4, 3, 7]

puts data.map { _1[:output] }.flatten.count { UNIQUE_SEGMENTS.include? _1.size }

def solve_entry(entry)
  patterns, output = entry[:patterns], entry[:output]
  candidates = {}
  candidates[1] = patterns.find { _1.size == 2 }
  candidates[4] = patterns.find { _1.size == 4 }
  candidates[7] = patterns.find { _1.size == 3 }
  candidates[8] = patterns.find { _1.size == 7 }
  fives = patterns.select { _1.size == 5 }
  sixes = patterns.select { _1.size == 6 }
  one = candidates[1].chars
  candidates[3] = fives.find { |pat| pat.chars.intersection(one).size == 2 }
  fives.delete candidates[3]
  candidates[6] = sixes.find { |pat| pat.chars.intersection(one).size == 1 }
  sixes.delete candidates[6]
  six = candidates[6].chars
  candidates[2] = fives.find { |pat| pat.chars.intersection(six).size == 4 }
  candidates[5] = fives.find { |pat| pat.chars.intersection(six).size == 5 }
  three = candidates[3].chars
  candidates[0] = sixes.find { |pat| pat.chars.intersection(three).size == 4 }
  candidates[9] = sixes.find { |pat| pat.chars.intersection(three).size == 5 }

  map = Hash[candidates.map { [_2, _1] }]
  output.map { map[_1] }.join.to_i
end

puts data.map { solve_entry _1 }.sum
