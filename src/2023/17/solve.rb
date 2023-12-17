#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'

require_relative '../../../lib/pqueue'

GRID = Hash[ARGF.readlines(chomp: true).flat_map.with_index { |line, y|
  line.chars.map.with_index { |c, x| [Vector[x, y], c.to_i] }
}].tap { _1.default = Float::INFINITY }

WIDTH = GRID.keys.map { _1[0] }.max + 1
HEIGHT = GRID.keys.map { _1[1] }.max + 1

START = Vector[0, 0]
GOAL = Vector[WIDTH - 1, HEIGHT - 1]

DIRS = %i[R L D U]
OPPOSITES = { R: :L, L: :R, D: :U, U: :D }
DIR_TO_V = { R: Vector[1, 0], L: Vector[-1, 0], D: Vector[0, 1], U: Vector[0, -1] }

def neighbors(current, last_dir, min, max)
  valid_dirs = DIRS - [last_dir, OPPOSITES[last_dir]]
  valid_dirs.flat_map { |dir|
    v = DIR_TO_V[dir]
    (min..max).map { |m|
      cost = 0
      m.times { |i| cost += GRID[current + v * (i + 1)] }
      [current + v * m, dir, cost]
    }
  }.reject { |p, _, _| p[0] < 0 || p[0] >= WIDTH || p[1] < 0 || p[1] >= HEIGHT }
end

def solve(source = START, target = GOAL, &neighbors)
  queue = PriorityQueue.new
  queue.enqueue [source, nil, 0], 0
  seen = Set.new

  while queue.any?
    current, last_dir, cost = queue.dequeue
    next unless seen.add? [current, last_dir]
    return cost if current == target
    neighbors.call(current, last_dir).each do |np, d, c|
      queue.enqueue [np, d, cost + c], cost + c
    end
  end
end

puts solve { neighbors(_1, _2, 1, 3) }
puts solve { neighbors(_1, _2, 4, 10) }
