#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'

GRID = Hash[ARGF.readlines(chomp: true).flat_map.with_index { |line, y|
  line.chars.map.with_index { |c, x| [Vector[x, y], c] }
}]

WIDTH = GRID.keys.map { _1[0] }.max + 1
HEIGHT = GRID.keys.map { _1[1] }.max + 1

DIRS = {
  UP: Vector[0, -1],
  DOWN: Vector[0, 1],
  LEFT: Vector[-1, 0],
  RIGHT: Vector[1, 0]
}.freeze

def solve(start)
  queue = [start]
  seen = Set.new

  while queue.any?
    beam = queue.shift
    pos, dir = beam
    next if pos[0] < 0 || pos[0] >= WIDTH || pos[1] < 0 || pos[1] >= HEIGHT
    next unless seen.add? beam
    tile = GRID[pos]
    if tile == '-' && (dir == DIRS[:UP] || dir == DIRS[:DOWN])
      queue.push [pos + DIRS[:LEFT], DIRS[:LEFT]]
      queue.push [pos + DIRS[:RIGHT], DIRS[:RIGHT]]
    elsif tile == '|' && (dir == DIRS[:RIGHT] || dir == DIRS[:LEFT])
      queue.push [pos + DIRS[:UP], DIRS[:UP]]
      queue.push [pos + DIRS[:DOWN], DIRS[:DOWN]]
    elsif tile == '/' && dir == DIRS[:RIGHT]
      queue.push [pos + DIRS[:UP], DIRS[:UP]]
    elsif tile == '/' && dir == DIRS[:LEFT]
      queue.push [pos + DIRS[:DOWN], DIRS[:DOWN]]
    elsif tile == '/' && dir == DIRS[:UP]
      queue.push [pos + DIRS[:RIGHT], DIRS[:RIGHT]]
    elsif tile == '/' && dir == DIRS[:DOWN]
      queue.push [pos + DIRS[:LEFT], DIRS[:LEFT]]
    elsif tile == '\\' && dir == DIRS[:RIGHT]
      queue.push [pos + DIRS[:DOWN], DIRS[:DOWN]]
    elsif tile == '\\' && dir == DIRS[:LEFT]
      queue.push [pos + DIRS[:UP], DIRS[:UP]]
    elsif tile == '\\' && dir == DIRS[:UP]
      queue.push [pos + DIRS[:LEFT], DIRS[:LEFT]]
    elsif tile == '\\' && dir == DIRS[:DOWN]
      queue.push [pos + DIRS[:RIGHT], DIRS[:RIGHT]]
    elsif tile == '.' || tile == '-' || tile == '|' || tile == '/' || tile == '\\'
      queue.push [pos + dir, dir]
    end
  end

  seen.map(&:first).uniq.size
end

puts solve([Vector[0, 0], DIRS[:RIGHT]])

starts = (0...WIDTH).flat_map { |x|
  (0...HEIGHT).map { |y| Vector[x, y] }
}.select {
  _1[0] == 0 || _1[1] == 0 || _1[0] == WIDTH - 1 || _1[1] == HEIGHT - 1
}.flat_map { |pos|
  a = []
  a.push [pos, DIRS[:RIGHT]] if pos[0] == 0
  a.push [pos, DIRS[:LEFT]] if pos[0] == WIDTH - 1
  a.push [pos, DIRS[:UP]] if pos[1] == HEIGHT - 1
  a.push [pos, DIRS[:DOWN]] if pos[1] == 0
  a
}

puts starts.map { solve _1 }.max
