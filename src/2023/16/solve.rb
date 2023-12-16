#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

GRID = ARGF.readlines(chomp: true).map(&:chars)
HEIGHT, WIDTH = GRID.size, GRID[0].size

U, D, L, R = 0, 1, 2, 3
DIRS = [[0, -1], [0, 1], [-1, 0], [1, 0]]

def cantor(x, y)
  ((x + y) * (x + y + 1)) / 2 + y
end

def cantor3(x, y, z)
  cantor(cantor(x, y), z)
end

def solve(start)
  queue = [start]
  seen = Set.new [cantor3(*start)]
  lit = Set.new [cantor(start[0], start[1])]

  while queue.any?
    x, y, dir = queue.shift
    dx, dy = DIRS[dir]

    while x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT
      tile = GRID[y][x]
      lit.add cantor(x, y)
      if tile == '-' && dy != 0
        queue.push [x, y, L] if seen.add? cantor3(x, y, L)
        queue.push [x, y, R] if seen.add? cantor3(x, y, R)
        break
      elsif tile == '|' && dx != 0
        queue.push [x, y, U] if seen.add? cantor3(x, y, U)
        queue.push [x, y, D] if seen.add? cantor3(x, y, D)
        break
      elsif tile == '/'
        dx, dy = dy * -1, dx * -1
      elsif tile == '\\'
        dx, dy = dy, dx
      end

      x += dx
      y += dy
    end
  end

  lit.size
end

puts solve([0, 0, R])

starts = (0...WIDTH).flat_map { |x|
  (0...HEIGHT).map { |y| [x, y] }
}.select { |(x, y)|
  x == 0 || y == 0 || x == WIDTH - 1 || y == HEIGHT - 1
}.flat_map { |(x, y)|
  a = []
  a.push [x, y, R] if x == 0
  a.push [x, y, L] if x == WIDTH - 1
  a.push [x, y, U] if y == HEIGHT - 1
  a.push [x, y, D] if y == 0
  a
}

puts starts.map { solve _1 }.max
