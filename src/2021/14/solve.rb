#!/usr/bin/env ruby
# frozen_string_literal: true

TEMPLATE = ARGF.readline.strip
FIRST, LAST = [TEMPLATE[0], TEMPLATE[-1]]
PAIRS = TEMPLATE.chars.each_cons(2).tally
ARGF.readline
RULES = ARGF.read.scan(/(..) -> (.)/).to_h { [_1.chars, _2] }.freeze

def step(pairs)
  result = Hash.new(0)
  pairs.each do |pair, count|
    if RULES.key? pair
      char = RULES[pair]
      result[[pair[0], char]] += count
      result[[char, pair[1]]] += count
    else
      result[pair] += count
    end
  end
  result
end

def count(pairs)
  pairs.map { |(a, b), n| [[a, n], [b, n]] }.flatten(1).each_with_object(Hash.new(0)) do |(c, n), h|
    h[c] += n
  end.tap do |h|
    h[FIRST] += 1
    h[LAST] += 1
    h.each_key { h[_1] /= 2 }
  end
end

puts count(10.times.reduce(PAIRS) { step(_1) }).values.minmax.reverse.reduce(:-) # rubocop:disable Lint/UnexpectedBlockArity
puts count(40.times.reduce(PAIRS) { step(_1) }).values.minmax.reverse.reduce(:-) # rubocop:disable Lint/UnexpectedBlockArity
