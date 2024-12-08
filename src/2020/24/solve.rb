#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

DELTAS = {
  nw: ->c { c[1].even? ? Vector[-1, -1] : Vector[0, -1] },
  ne: ->c { c[1].even? ? Vector[0, -1] : Vector[1, -1] },
  se: ->c { c[1].even? ? Vector[0, 1] : Vector[1, 1] },
  sw: ->c { c[1].even? ? Vector[-1, 1] : Vector[0, 1] },
  e: ->_ { Vector[1, 0] },
  w: ->_ { Vector[-1, 0] }
}

def adjacent(pos)
  DELTAS.map { pos + _2[pos] }
end

def calc_dest(start, path)
  path.reduce(start) { _1 + DELTAS[_2][_1] }
end

paths = ARGF.readlines.map(&:strip)
dirs = paths.map do |p|
  p.scan(/nw|ne|se|sw|e|w/).map(&:to_sym)
end

dests = dirs.map { calc_dest Vector[0, 0], _1 }
counts = dests.each_with_object(Hash.new(0)) { _2[_1] += 1 }

puts counts.count { _2.odd? }

grid = Hash[counts.map { [_1, _2.even? ? :white : :black] }]
grid.default = :white

def minmax(grid)
  min_x, max_x = grid.keys.map { _1[0] }.minmax
  min_y, max_y = grid.keys.map { _1[1] }.minmax
  [Vector[min_x, min_y], Vector[max_x, max_y]]
end

def step(grid)
  toflip = []
  min_pos, max_pos = minmax grid

  (min_pos[1] - 1..max_pos[1] + 1).each do |y|
    (min_pos[0] - 1..max_pos[0] + 1).each do |x|
      pos = Vector[x, y]
      current = grid[pos]
      black = adjacent(pos).count { grid[_1] == :black }
      if (current == :black && (black == 0 || black > 2)) || (current == :white && black == 2)
        toflip << pos
      end
    end
  end
  toflip.each { grid[_1] = grid[_1] == :white ? :black : :white }
end

100.times { step grid }

puts grid.count { _2 == :black }
