#!/usr/bin/env ruby
# frozen_string_literal: true

#   \ n  /
# nw +--+ ne
#   /    \
# -+      +-
#   \    /
# sw +--+ se
#   / s  \

# https://www.redblobgames.com/grids/hexagons/

require 'matrix'

class Vector
  def x = self[0]
  def y = self[1]
  def z = self[2]
end

DIRECTIONS = {
  n: Vector[0, 1, -1],
  ne: Vector[1, 0, -1],
  se: Vector[1, -1, 0],
  s: Vector[0, -1, 1],
  sw: Vector[-1, 0, 1],
  nw: Vector[-1, 1, 0]
}

ORIGIN = Vector[0, 0, 0]

def cube_distance(a, b)
  ((a.x - b.x).abs + (a.y - b.y).abs + (a.z - b.z).abs) / 2
end

path = ARGF.read.strip.split(',').map(&:to_sym)

max_dist = 0

pos = path.map { |d| DIRECTIONS[d] }.reduce(Vector[0, 0, 0]) do |current, change|
  new_pos = current + change
  new_dist = cube_distance(ORIGIN, new_pos)
  max_dist = new_dist if new_dist > max_dist
  new_pos
end

puts cube_distance(ORIGIN, pos)
puts max_dist
