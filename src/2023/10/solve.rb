#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

FANCIES = {
  '|': '│',
  '-': '─',
  L: '└',
  J: '┘',
  '7': '┐',
  F: '┌',
  '.': '·'
}

def display(grid)
  height = grid.keys.map { _1[1] }.max + 1
  width = grid.keys.map { _1[0] }.max + 1
  (0...height).each do |row|
    (0...width).each do |col|
      print FANCIES[grid[Vector[col, row]]]
    end
    puts
  end
end

grid = {}
start = nil

ARGF.readlines(chomp: true).each_with_index do |line, y|
  line.chars.each_with_index do |tile, x|
    grid[Vector[x, y]] = tile.to_sym
    start = Vector[x, y] if tile == ?S
  end
end

WIDTH = grid.keys.map { _1[0] }.max + 1
HEIGHT = grid.keys.map { _1[1] }.max + 1

NEIGHBORS = {
  '|': [Vector[0, -1], Vector[0, 1]],
  '-': [Vector[-1, 0], Vector[1, 0]],
  L: [Vector[0, -1], Vector[1, 0]],
  J: [Vector[0, -1], Vector[-1, 0]],
  '7': [Vector[-1, 0], Vector[0, 1]],
  F: [Vector[1, 0], Vector[0, 1]]
}.tap { _1.default = [] }

grid[start] = NEIGHBORS.find { |_, ds|
  ds.all? { |d| NEIGHBORS[grid[start + d]].any? { _1 == d * -1 } }
}[0]

dists = Hash.new(Float::INFINITY).tap { _1[start] = 0 }
STARTS = NEIGHBORS[grid[start]]

STARTS.each do |start_dir|
  seen = Set.new [start]
  current = start + start_dir
  cost = 1
  while !current.nil? && current != start
    seen.add current
    dists[current] = cost if cost < dists[current]
    cands = NEIGHBORS[grid[current]].map { current + _1 }
    current = cands.reject { !grid.include?(_1) || seen.include?(_1) }[0]
    cost += 1
  end
end

puts dists.values.max

(grid.keys - dists.keys).each { grid[_1] = :'.' }

FLIPS = Set.new %i[| F 7]
inside_count = 0

(0...HEIGHT).each do |y|
  state = false
  (0...WIDTH).each do |x|
    type = grid[Vector[x, y]]
    if FLIPS.include?(type)
      state = !state
    elsif type == :'.' && state
      inside_count += 1
    end
  end
end

puts inside_count
