#!/usr/bin/env ruby
# frozen_string_literal: true

TEMPLATE = ARGF.readline.strip
FIRST, LAST = [TEMPLATE[0], TEMPLATE[-1]]
PAIRS = TEMPLATE.chars.each_cons(2).tally
ARGF.readline
rules = Hash[ARGF.read.scan(/(..) -> (.)/).map { [_1.chars, _2] }].freeze

def step(pairs)
  result = Hash.new(0)
  pairs.each do |pair, count|
    if rules.key? pair
      char = rules[pair]
      result[[pair[0], char]] += count
      result[[char, pair[1]]] += count
    else
      result[pair] += count
    end
  end
  result
end

def count(pairs)
  pairs.map { |(a, b), n| [[a, n], [b, n]] }.flatten(1).reduce(Hash.new(0)) do |h, (c, n)|
    h[c] += n
    h
  end.tap do |h|
    h[FIRST] += 1
    h[LAST] += 1
    h.keys.each { h[_1] /= 2 }
  end
end

puts count(10.times.reduce(PAIRS) { step(_1) }).values.minmax.reverse.reduce(:-)
puts count(40.times.reduce(PAIRS) { step(_1) }).values.minmax.reverse.reduce(:-)
