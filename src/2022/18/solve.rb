#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

cubes = ARGF.readlines.map { Vector[*_1.split(',').map(&:to_i)] }.to_set
MIN = Vector[cubes.map { _1[0] }.min, cubes.map { _1[1] }.min, cubes.map { _1[2] }.min]
MAX = Vector[cubes.map { _1[0] }.max, cubes.map { _1[1] }.max, cubes.map { _1[2] }.max]

ADJ = [
  Vector[1, 0, 0],
  Vector[-1, 0, 0],
  Vector[0, 1, 0],
  Vector[0, -1, 0],
  Vector[0, 0, 1],
  Vector[0, 0, -1]
]

def adjacent(cube)
  ADJ.map { cube + _1 }
end

def outside?(pos)
  pos[0] < MIN[0] || pos[0] > MAX[0] || pos[1] < MIN[1] || pos[1] > MAX[1] || pos[2] < MIN[2] || pos[2] > MAX[2]
end

puts cubes.sum { |cube| 6 - adjacent(cube).count { cubes.include?(_1) } }

air = []
(MIN[0]..MAX[0]).each do |x|
  (MIN[1]..MAX[1]).each do |y|
    (MIN[2]..MAX[2]).each do |z|
      v = Vector[x, y, z]
      air.push v unless cubes.include?(v)
    end
  end
end

while air.any?
  pos = air.shift
  visited = Set[pos]
  queue = adjacent(pos)

  reached_outside = false

  while queue.any?
    pos = queue.shift
    visited.add pos

    if outside?(pos)
      reached_outside = true
    elsif !cubes.include?(pos)
      adj = adjacent(pos).reject { visited.include?(_1) || queue.include?(_1) }
      queue.concat adj
    end
  end

  if !reached_outside
    cubes.merge visited
  end

  air -= visited.to_a
end

puts cubes.sum { |cube| 6 - adjacent(cube).count { cubes.include?(_1) } }
