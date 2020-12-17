#!/usr/bin/env ruby

require_relative '../lib/astar'
require_relative '../lib/grid'

def heuristic(a, b)
  x1, y1 = a.to_a
  x2, y2 = b.to_a
  (x1 - x2).abs + (y1 - y2).abs
end

diagram4 = GridWithWeights.new 10, 10
diagram4.walls = [[1, 7], [1, 8], [2, 7], [2, 8], [3, 7], [3, 8]].map { Vector[*_1] }

start, goal = Vector[1, 4], Vector[1, 9]
came_from, cost_so_far = AStar.find_path(diagram4, start, goal, &method(:heuristic))
diagram4.draw point_to: came_from, start: start, goal: goal
path = AStar.reconstruct_path(came_from, start, goal)
diagram4.draw path: path
diagram4.draw number: cost_so_far, start: start, goal: goal

puts "Shortest path has cost #{cost_so_far[goal]}"
