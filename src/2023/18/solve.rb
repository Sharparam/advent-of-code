#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

DIRMAP = { ?R => 0, ?D => 1, ?L => 2, ?U => 3 }
DIRS = [Vector[1, 0], Vector[0, 1], Vector[-1, 0], Vector[0, -1]]

def manhattan(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

def shoelace(vertices)
  vertices.each_cons(2).sum { |c, n|
    c[0] * n[1] - n[0] * c[1] + manhattan(c, n)
  } / 2 + 1
end

puts ARGF.read.scan(/([RDLU]) (\d+) \(#(\w+)(\d)\)/).reduce([[Vector[0, 0]], [Vector[0, 0]]]) { |a, (d1, c1, c2, d2)|
  [
    [*a[0], a[0][-1] + DIRS[DIRMAP[d1]] * c1.to_i],
    [*a[1], a[1][-1] + DIRS[d2.to_i] * c2.to_i(16)]
  ]
}.map { shoelace _1 }
