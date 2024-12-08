#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

P1, P2 = ARGF.read.split("\n\n").map { _1.split("\n").drop 1 }.map { |d| d.map(&:to_i) }
p1, p2 = P1.dup, P2.dup

while p1.any? && p2.any?
  c1, c2 = p1.shift, p2.shift
  r = [c1, c2].sort.reverse
  if c1 > c2
    p1.concat r
  else
    p2.concat r
  end
end

w = p1.any? ? p1 : p2

s = w.size
puts w.map.with_index { _1 * (s - _2) }.sum

def rcombat(p1, p2)
  seen = Set.new
  winner = 0

  while p1.any? && p2.any?
    conf = [p1.hash, p2.hash].hash
    if seen.include? conf
      winner = 1
      break
    end
    seen.add conf

    cs = [p1.shift, p2.shift]
    r = cs.sort.reverse

    if p1.size >= cs[0] && p2.size >= cs[1]
      winner = rcombat(p1.take(cs[0]), p2.take(cs[1]))[0]
      r = [cs[winner - 1], cs[winner % 2]]
    elsif cs[0] > cs[1]
      winner = 1
    else
      winner = 2
    end

    if winner == 1
      p1.concat r
    else
      p2.concat r
    end
  end

  [winner, p1, p2]
end

r = rcombat(P1.dup, P2.dup)
w = r[r[0]]
puts w.map.with_index { _1 * (s - _2) }.sum
