#!/usr/bin/env ruby
# frozen_string_literal: true

GRID = ARGF.readlines.map { |l| l.scan(/\d/).map(&:to_i) }
TRANSPOSED = GRID.transpose

WIDTH = GRID[0].size
HEIGHT = GRID.size

def score(x, y)
  val = GRID[y][x]
  left = GRID[y][..x - 1]
  right = GRID[y][x + 1..]
  up = TRANSPOSED[x][..y - 1]
  down = TRANSPOSED[x][y + 1..]
  dirs = [left, right, up, down]

  is_edge = x == 0 || y == 0 || x >= WIDTH - 1 || y >= HEIGHT - 1
  is_visible = is_edge || dirs.any? { |d| d.all? { _1 < val } }

  if is_edge
    score = 0
  else
    left_index = left.reverse.find_index { _1 >= val }
    left_count = left_index.nil? ? x : left_index + 1
    right_index = right.find_index { _1 >= val }
    right_count = right_index.nil? ? right.size : right_index + 1
    up_index = up.reverse.find_index { _1 >= val }
    up_count = up_index.nil? ? y : up_index + 1
    down_index = down.find_index { _1 >= val }
    down_count = down_index.nil? ? down.size : down_index + 1
    score = left_count * right_count * up_count * down_count
  end

  [is_visible ? 1 : 0, score]
end

result = (0..HEIGHT - 1).reduce([0, 0]) do |a, y|
  inter = (0..WIDTH - 1).reduce([0, 0]) do |i, x|
    s = score(x, y)
    [i[0] + s[0], [s[1], i[1]].max]
  end

  [a[0] + inter[0], [inter[1], a[1]].max]
end

puts result[0]
puts result[1]
