#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'benchmark'

require_relative '../../../lib/astar'
require_relative '../../../lib/grid'

class MyGrid < GridWithWeights
  def neighbors(pos)
    positions = super(pos)
    positions.reject { |p| cost(pos, p) > 1 }
  end

  def cost(source, destination)
    sv, dv = @weights[source], @weights[destination]
    dv - sv > 1 ? 9999 : 1
  end
end

cells = ARGF.readlines.map { _1.chomp.chars }
start_y = cells.find_index { _1.include? ?S }
start_x = cells[start_y].find_index { _1 == ?S }
goal_y = cells.find_index { _1.include? ?E }
goal_x = cells[goal_y].find_index { _1 == ?E }

start = Vector[start_x, start_y]
goal = Vector[goal_x, goal_y]

heights = { ?S => ?a.ord, ?E => ?z.ord }.tap { _1.default_proc = -> (_, k) { k.ord } }
cells = cells.map { |l| l.map { heights[_1] } }

grid = MyGrid.new(cells[0].size, cells.size)
positions = (0...grid.width).to_a.product((0...grid.height).to_a).map { Vector[*_1] }
positions.each do |pos|
  grid.add_weight(pos, cells[pos[1]][pos[0]])
end

_, costs = AStar.find_path(grid, start, goal)
puts costs[goal]

starts = positions.select { |pos| cells[pos[1]][pos[0]] == ?a.ord }
puts AStar.find_path(grid, starts, goal)[1][goal]
