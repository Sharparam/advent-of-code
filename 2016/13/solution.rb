#!/usr/bin/env ruby

require 'matrix'
require 'set'

require_relative '../../lib/astar'

INPUT = ARGV[0]&.to_i || 1364
GOAL = Vector[*(ARGV[1] || '31,39').split(?,).map(&:to_i)]
ADJACENTS = [
          [0, -1],
  [-1, 0],        [1, 0],
          [0, 1]
].map { Vector[*_1] }

class Vector
  def x; self[0]; end
  def y; self[1]; end
end

class InfGrid
  def neighbors(pos)
    ADJACENTS.map { pos + _1 }.select do
      !is_wall?(_1) && _1.x >= 0 && _1.y >= 0
    end
  end

  def cost(_source, _destination)
    1
  end

  private

  def is_wall?(pos)
    x, y = pos.x, pos.y
    value = x * x + 3 * x + 2 * x * y + y + y * y + INPUT
    (value.to_s(2).chars.count(?1)) % 2 != 0
  end
end

GRID = InfGrid.new
START = Vector[1, 1]
_, cost_so_far = AStar.find_path(GRID, START, GOAL)

puts cost_so_far[GOAL]

queue = [START]
dist = { START => 0 }
while pos = queue.shift
  GRID.neighbors(pos).each do |adj|
    next if dist.include? adj
    dist[adj] = dist[pos] + 1
    queue << adj
  end
end

puts dist.values.count { _1 <= 50 }
