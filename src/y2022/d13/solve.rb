#!/usr/bin/env ruby
# frozen_string_literal: true

pairs = ARGF.read.split("\n\n").map { |b| b.lines.map { |l| eval l } }

def check(a, b)
  return a <=> b if a.is_a?(Numeric) && b.is_a?(Numeric)

  a.each_with_index do |av, i|
    bv = b[i]
    return 1 if bv.nil?

    if av.is_a?(Enumerable) && !bv.is_a?(Enumerable)
      bv = [bv]
    elsif !av.is_a?(Enumerable) && bv.is_a?(Enumerable)
      av = [av]
    end

    if av.is_a?(Enumerable) && bv.is_a?(Enumerable)
      nested = check(av, bv)
      return nested if nested == -1 || nested == 1
    elsif av < bv
      return -1
    elsif av > bv
      return 1
    end
  end

  a.size <=> b.size
end

puts pairs.map.with_index.select { |p, _i| check(p[0], p[1]) == -1 }.map { _2 + 1 }.sum

packets = (pairs.flatten(1) + [[[2]], [[6]]]).sort { check _1, _2 }

puts (packets.find_index([[2]]) + 1) * (packets.find_index([[6]]) + 1)
