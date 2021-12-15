#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../lib/astar'
require_relative '../../lib/grid'

input = ARGF.readlines.map(&:strip).map { _1.split('').map(&:to_i) }
WIDTH = input[0].size
HEIGHT = input.size
START = Vector[0, 0]
GOAL = Vector[WIDTH - 1, HEIGHT - 1]
FULL_WIDTH = WIDTH * 5
FULL_HEIGHT = HEIGHT * 5
FULL_GOAL = Vector[FULL_WIDTH - 1, FULL_HEIGHT - 1]

grid = GridWithWeights.new(WIDTH, HEIGHT)
full_grid = GridWithWeights.new(FULL_WIDTH, FULL_HEIGHT)

input.each_with_index do |row, y|
  row.each_with_index do |weight, x|
    grid.add_weight Vector[x, y], weight
    full_grid.add_weight Vector[x, y], weight
    (1..4).each do |n|
      (0..4).each do |n2|
        new_weight = weight + n + n2
        new_weight -= 9 if new_weight > 9

        full_grid.add_weight Vector[x + (WIDTH * n), y + (HEIGHT * n2)], new_weight
        full_grid.add_weight Vector[x + (WIDTH * n2), y + (HEIGHT * n)], new_weight
      end
    end
  end
end

_, costs = AStar.find_path(grid, START, GOAL)
_, full_costs = AStar.find_path(full_grid, START, FULL_GOAL)

puts costs[GOAL]
puts full_costs[FULL_GOAL]
