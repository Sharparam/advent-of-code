#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'

FANCIES = {
  '|': '│',
  '-': '─',
  L: '└',
  J: '┘',
  '7': '┐',
  F: '┌',
  '.': '·',
  dot: '·',
  wall: '█',
  empty: ' '
}

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

DIRS = {
  C: Vector[0, 0],
  N: Vector[0, -1],
  S: Vector[0, 1],
  W: Vector[-1, 0],
  E: Vector[1, 0],
  NE: Vector[1, -1],
  NW: Vector[-1, -1],
  SE: Vector[1, 1],
  SW: Vector[-1, 1]
}

neighbours = {
  '|': [Vector[0, -1], Vector[0, 1]],
  '-': [Vector[-1, 0], Vector[1, 0]],
  L: [Vector[0, -1], Vector[1, 0]],
  J: [Vector[0, -1], Vector[-1, 0]],
  '7': [Vector[-1, 0], Vector[0, 1]],
  F: [Vector[1, 0], Vector[0, 1]]
}

large_tiles = {
  '|': { type: :wall, fill: [DIRS[:N], Vector[0, 0], DIRS[:S]] },
  '-': { type: :wall, fill: [DIRS[:W], Vector[0, 0], DIRS[:E]] },
  L: { type: :wall, fill: [DIRS[:N], Vector[0, 0], DIRS[:E]] },
  J: { type: :wall, fill: [DIRS[:N], Vector[0, 0], DIRS[:W]] },
  '7': { type: :wall, fill: [DIRS[:W], Vector[0, 0], DIRS[:S]] },
  F: { type: :wall, fill: [DIRS[:E], Vector[0, 0], DIRS[:S]] },
  '.': { type: :dot, fill: [Vector[0, 0]] }
}

neighbours.keys.each do |type|
  case type
  when :'|'
    next if start[1] == 0 || start[1] == HEIGHT - 1
    next unless %i[| 7 F].include?(grid[start + Vector[0, -1]])
    next unless %i[| L J].include?(grid[start + Vector[0, 1]])
  when :'-'
    next if start[0] == 0 || start[0] == WIDTH - 1
    next unless %i[- L F].include? grid[start + Vector[-1, 0]]
    next unless %i[- J 7].include? grid[start + Vector[1, 0]]
  when :L
    next if start[1] == 0 || start[0] == WIDTH - 1
    next unless %i[| 7 F].include? grid[start + Vector[0, -1]]
    next unless %i[- J 7].include? grid[start + Vector[1, 0]]
  when :J
    next if start[1] == 0 || start[0] == 0
    next unless %i[| 7 F].include? grid[start + Vector[0, -1]]
    next unless %i[- L F].include? grid[start + Vector[-1, 0]]
  when :'7'
    next if start[0] == 0 || start[1] == HEIGHT - 1
    next unless %i[- L F].include? grid[start + Vector[-1, 0]]
    next unless %i[| L J].include? grid[start + Vector[0, 1]]
  when :F
    next if start[0] == WIDTH - 1 || start[1] == HEIGHT - 1
    next unless %i[- J 7].include? grid[start + Vector[1, 0]]
    next unless %i[| L J].include? grid[start + Vector[0, 1]]
  end
  grid[start] = type
  break
end

dists = Hash.new(Float::INFINITY)

dists[start] = 0


dirs = neighbours[grid[start]]

dirs.each do |start_dir|
  seen = Set.new [start]
  current = start + start_dir
  cost = 1
  while !current.nil? && current != start
    seen.add current
    dists[current] = cost if cost < dists[current]
    cands = neighbours[grid[current]].map { current + _1 }
    current = cands.reject { !grid.include?(_1) || seen.include?(_1) }[0]
    cost += 1
  end
end

puts dists.values.max

loop_tiles = dists.keys

(grid.keys - loop_tiles).each { grid[_1] = :'.' }

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

large_grid = {}

grid.each do |pos, tile|
  pos = Vector[pos[0] * 3, pos[1] * 3]
  large_tile = large_tiles[tile]
  type = large_tile[:type]
  fill = large_tile[:fill]
  DIRS.values.each {
    new = pos + _1
    t = fill.include?(_1) ? type : :empty
    if large_grid[new].nil? || (large_grid[new] == :empty && t != :empty)
      large_grid[new] = t
    end
  }
end

# display grid
# display large_grid

NEXT = [DIRS[:N], DIRS[:S], DIRS[:W], DIRS[:E]]

width = large_grid.keys.map { _1[0] }.max + 1
height = large_grid.keys.map { _1[1] }.max + 1

outside = Set.new
visited = Set.new

queue = large_grid.select { |p, t| t != :wall && (p[0] == 0 || p[0] == width - 1 || p[1] == 0 || p[1] == height - 1) }.map { |p, _| p }

while queue.any?
  current = queue.shift
  next if visited.include? current
  visited.add current
  outside.add current if large_grid[current] == :dot
  around = NEXT.map { current + _1 }.reject {
    visited.include?(_1) || queue.include?(_1) ||
    _1[0] < 0 || _1[0] > width - 2 ||
    _1[1] < 0 || _1[1] > height - 2 ||
    large_grid[_1] == :wall
  }
  queue.concat around
end

outside_count = outside.size
total_count = large_grid.count { |_, t| t == :dot }
inside_count = total_count - outside_count

puts inside_count
