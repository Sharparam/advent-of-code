#!/usr/bin/env ruby
# frozen_string_literal: true

CARD_VALUES = %w[A K Q J T 9 8 7 6 5 4 3 2].reverse.map.with_index { [_1, _2] }.to_h

NON_J = CARD_VALUES.keys.reject { _1 == 'J' }

TYPE_VALUES = {
  five: 7,
  four: 6,
  full: 5,
  three: 4,
  two: 3,
  one: 2,
  high: 1
}.freeze

def type(hand, part2: false)
  hand = hand.chars if hand.is_a?(String)
  if part2 && hand.include?('J')
    return NON_J.map { |c| type(hand.map { _1 == 'J' ? c : _1 }, false) }.max_by { TYPE_VALUES[_1] }
  end
  t = hand.tally.values.sort.reverse
  return :five if t[0] == 5
  return :high if t.size == 5
  return :four if t[0] == 4
  return :full if t.size == 2 && t[0] == 3 && t[1] == 2
  return :three if t.size == 3 && t[0] == 3
  return :two if t.size == 3 && t[0] == 2 && t[1] == 2
  :one
end

def strength(item, part2: false)
  return CARD_VALUES[item] if item.is_a?(String) && item.size == 1
  TYPE_VALUES[type(item, part2)]
end

def compare(a, b, part2: false)
  a_s, b_s = strength(a, part2), strength(b, part2)
  return b_s <=> a_s if a_s != b_s

  a.each_with_index do
    return CARD_VALUES[b[_2]] <=> CARD_VALUES[_1] if _1 != b[_2]
  end

  0
end

sets = ARGF.readlines.map(&:split).map { [_1.chars, _2.to_i] }

puts sets.sort { compare(_1[0], _2[0]) }.reverse.map.with_index { [_1, _2] }.sum { _1[1] * (_2 + 1) }

CARD_VALUES['J'] = -1

puts sets.sort { compare(_1[0], _2[0], true) }.reverse.map.with_index { [_1, _2] }.sum { _1[1] * (_2 + 1) }
