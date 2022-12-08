#!/usr/bin/env ruby
# frozen_string_literal: true

GRID = ARGF.readlines.map { |l| l.scan(/\d/).map(&:to_i) }
TRANSPOSED = GRID.transpose

WIDTH = GRID[0].size
HEIGHT = GRID.size

def visible?(x, y)
  return true if x == 0 || y == 0 || x >= WIDTH - 1 || y >= HEIGHT - 1
  val = GRID[y][x]
  dirs = [GRID[y][..x - 1], GRID[y][x + 1..], TRANSPOSED[x][..y - 1], TRANSPOSED[x][y + 1..]]

  dirs.any? { |d| d.all? { _1 < val } }
end

puts (0..HEIGHT - 1).sum { |y| (0..WIDTH - 1).count { |x| visible? x, y }}
