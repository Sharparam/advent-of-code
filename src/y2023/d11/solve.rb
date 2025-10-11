#!/usr/bin/env ruby
# frozen_string_literal: true

POSITIONS = ARGF.readlines(chomp: true).flat_map.with_index { |line, y|
  line.chars.map.with_index { [_1, _2] }.select { |c, _| c == ?# }.map { [_2, y] }
}

XS, YS = POSITIONS.map { [_1[0], _1[1]] }.transpose.map(&:to_set)

WIDTH = XS.max + 1
HEIGHT = YS.max + 1

EMPTY_X = (0...WIDTH).reject { XS.include?(_1) }.to_set
EMPTY_Y = (0...HEIGHT).reject { YS.include?(_1) }.to_set

def dist(a, b)
  x1, x2, y1, y2 = a[0], b[0], a[1], b[1]
  x_min, x_max = [x1, x2].minmax
  y_min, y_max = [y1, y2].minmax
  ex = (x_min..x_max).count { EMPTY_X.include? _1 }
  ey = (y_min..y_max).count { EMPTY_Y.include? _1 }
  dist = (x1 - x2).abs + (y1 - y2).abs
  [dist + ex + ey, dist + (ex * 999_999) + (ey * 999_999)]
end

puts POSITIONS.combination(2).to_a.map { dist _1, _2 }.transpose.map(&:sum)
