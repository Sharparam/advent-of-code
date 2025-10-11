#!/usr/bin/env ruby
# frozen_string_literal: true

GRID = ARGF.readlines(chomp: true).map(&:chars)
HEIGHT, WIDTH = GRID.size, GRID[0].size

def cantor(x, y)
  (((x + y) * (x + y + 1)) / 2) + y
end

def solve(start)
  queue = [start]
  seen = Set.new [cantor(start[0], start[1])]
  lit = Set.new [cantor(start[0], start[1])]

  while queue.any?
    x, y, dx, dy = queue.shift

    while x >= 0 && x < WIDTH && y >= 0 && y < HEIGHT
      tile = GRID[y][x]
      lit.add cantor(x, y)
      if tile == '-' && dy != 0
        break unless seen.add? cantor(x, y)
        queue.push [x - 1, y, -1, 0]
        queue.push [x + 1, y, 1, 0]
        break
      elsif tile == '|' && dx != 0
        break unless seen.add? cantor(x, y)
        queue.push [x, y - 1, 0, -1]
        queue.push [x, y + 1, 0, 1]
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

puts solve([0, 0, 1, 0])

starts = (0...WIDTH).flat_map { |x|
  (0...HEIGHT).map { |y| [x, y] }
}.select { |(x, y)|
  x == 0 || y == 0 || x == WIDTH - 1 || y == HEIGHT - 1
}.flat_map { |(x, y)|
  a = []
  a.push [x, y, 1, 0] if x == 0
  a.push [x, y, -1, 0] if x == WIDTH - 1
  a.push [x, y, 0, -1] if y == HEIGHT - 1
  a.push [x, y, 0, 1] if y == 0
  a
}

puts starts.map { solve _1 }.max
