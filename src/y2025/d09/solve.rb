#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

reds = ARGF.map { Vector[*_1.split(',').map(&:to_i)] }

puts reds.combination(2).map { |a, b|
  ((a[0] - b[0]).abs + 1) * ((a[1] - b[1]).abs + 1)
}.max

greens = Set.new

reds.each_cons(2) do |s, e|
  if s[0] == e[0]
    x = s[0]
    if s[1] < e[1]
      y1, y2 = s[1], e[1]
    else
      y1, y2 = e[1], s[1]
    end
    (y1..y2).each { |y| greens.add(Vector[x, y]) }
  else
    y = s[1]
    if s[0] < e[0]
      x1, x2 = s[0], e[0]
    else
      x1, x2 = e[0], s[0]
    end
    (x1..x2).each { |x| greens.add(Vector[x, y]) }
  end
end

s = reds[-1]
e = reds[0]
if s[0] == e[0]
  x = s[0]
  if s[1] < e[1]
    y1, y2 = s[1], e[1]
  else
    y1, y2 = e[1], s[1]
  end
  (y1..y2).each { |y| greens.add(Vector[x, y]) }
else
  y = s[1]
  if s[0] < e[0]
    x1, x2 = s[0], e[0]
  else
    x1, x2 = e[0], s[0]
  end
  (x1..x2).each { |x| greens.add(Vector[x, y]) }
end

# p reds
# p greens
p reds.size
p greens.size
