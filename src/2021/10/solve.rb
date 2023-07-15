#!/usr/bin/env ruby
# frozen_string_literal: true

MAP = { '(' => ')', '[' => ']', '{' => '}', '<' => '>' }.freeze
POINTS = { ')' => 3, ']' => 57, '}' => 1197, '>' => 25137 }.freeze
SCORE = { ')' => 1, ']' => 2, '}' => 3, '>' => 4 }.freeze

illegal = 0
scores = []

ARGF.readlines.map(&:strip).each do |line|
  next_close = []
  incomplete = true
  line.chars.each do |char|
    if MAP.key? char
      next_close.push MAP[char]
    else
      expected = next_close.pop
      next if char == expected
      illegal += POINTS[char]
      incomplete = false
      break
    end
  end
  scores << next_close.reverse.reduce(0) { |a, e| (a * 5) + SCORE[e] } if incomplete
end

puts illegal
puts scores.sort[scores.size / 2]
