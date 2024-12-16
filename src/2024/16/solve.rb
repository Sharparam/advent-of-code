#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
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

def dfs2
  stack = [[START, Point[1, 0], Set.new, 0, [START, GOAL]]]
  min_cost = Float::INFINITY
  pos_mins = Hash.new Float::INFINITY
  paths = Hash.new { |h, k| h[k] = [] }

  until stack.empty?
    pos, dir, vis, cost, path = stack.pop
    next if cost > min_cost
    next if cost > pos_mins[pos] + 1000
    if pos == GOAL
      paths[cost] << path
      min_cost = cost if cost < min_cost
      next
    end
    pos_mins[pos] = cost if cost < pos_mins[pos]
    vis.add pos
    path << pos
    DIRS.each do |new_dir|
      new_pos = pos + new_dir
      if !vis.include?(new_pos) && MAZE[new_pos] != ?#
        turn_cost = new_dir == dir ? 0 : 1000
        stack.push [new_pos, new_dir, vis.dup, cost + turn_cost + 1, path.dup]
      end
    end
  end

  [min_cost, Set.new(paths[min_cost].flatten)]
end

part1, paths = dfs2

# display(paths)

puts part1
puts paths.size
