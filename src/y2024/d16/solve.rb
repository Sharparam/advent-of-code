#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'pairing_heap'
require 'aoc/point'

Point = AoC::Point2

MAZE = ARGF.readlines.flat_map.with_index { |line, y|
  line.chomp.chars.map.with_index { |cell, x|
    [Point[x, y], cell]
  }
}.to_h

START = MAZE.find { |p, c| c == ?S }[0]
GOAL = MAZE.find { |p, c| c == ?E }[0]

DIRS = [
  Point[1, 0], # Right
  Point[0, 1], # Down
  Point[-1, 0], # Left
  Point[0, -1] # Up
].freeze

def display(path)
  $width ||= MAZE.keys.map(&:x).max + 1
  $height ||= MAZE.keys.map(&:y).max + 1
  $height.times do |y|
    $width.times do |x|
      p = Point[x, y]
      c = MAZE[p]
      if c == ?. && path.include?(p)
        print 'O'
      else
        print c
      end
    end
    puts
  end
end

def solve
  heap = PairingHeap::SimplePairingHeap.new
  heap.push [START, Point[1, 0], Set.new, 0], 0
  min_cost = Float::INFINITY
  pos_mins = Hash.new Float::INFINITY
  paths = Hash.new { |h, k| h[k] = [] }

  until heap.empty?
    pos, dir, vis, cost = heap.pop
    next if cost > min_cost
    next if cost > pos_mins[pos] + 1000
    vis.add pos
    if pos == GOAL
      paths[cost] << vis
      min_cost = cost if cost < min_cost
      next
    end
    pos_mins[pos] = cost if cost < pos_mins[pos]
    DIRS.each do |new_dir|
      new_pos = pos + new_dir
      next if vis.include?(new_pos) || MAZE[new_pos] == ?#
      turn_cost = new_dir == dir ? 0 : 1000
      new_cost = cost + turn_cost + 1
      heap.push [new_pos, new_dir, vis.dup, new_cost], new_cost
    end
  end

  [min_cost, paths[min_cost].reduce(:|)]
end

part1, paths = solve

# display(paths)

puts part1
puts paths.size
