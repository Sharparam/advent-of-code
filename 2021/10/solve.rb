#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.readlines.map(&:strip)

OPEN = '([{<'.chars
CLOSE = ')]}>'.chars

MAP = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}.freeze

POINTS = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}.freeze

AC_SCORE = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}.freeze

illegal = []
autocomplete_scores = []

input.each do |line|
  next_close = []
  incomplete = true
  line.chars.each do |char|
    if MAP.key? char
      next_close.push MAP[char]
    else
      expected = next_close.pop
      next if char == expected
      illegal << char
      incomplete = false
      break
    end
  end
  next unless incomplete
  score = next_close.reverse.reduce(0) { |a, e| (a * 5) + AC_SCORE[e] }
  autocomplete_scores << score
end

puts illegal.map { |c| POINTS[c] }.sum
puts autocomplete_scores.sort[autocomplete_scores.size / 2]
