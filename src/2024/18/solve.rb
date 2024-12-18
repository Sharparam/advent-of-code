#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'matrix'
require 'pairing_heap'

WIDTH = 71
HEIGHT = 71

BYTES = ARGF.read.scan(/\d+/).map(&:to_i).each_slice(2).map { Vector[*_1] }

$grids = {}

def grid_at(nanosecond)
  return $grids[nanosecond] if $grids.key?(nanosecond)
  $grids[nanosecond] = BYTES[0..(nanosecond - 1)].to_h { [_1, :byte] }
end

def display(grid)
  HEIGHT.times.each do |y|
    WIDTH.times.each do |x|
      print grid[Vector[x, y]] == :byte ? '#' : '.'
    end
    puts
  end
end

DIRS = [
  Vector[1, 0], # Right
  Vector[0, 1], # Down
  Vector[-1, 0], # Left
  Vector[0, -1] # Up
].freeze

def neighbors(pos)
  DIRS.map { pos + _1 }.reject { _1[0] < 0 || _1[0] >= WIDTH || _1[1] < 0 || _1[1] >= HEIGHT }
end

START = Vector[0, 0]
GOAL = Vector[WIDTH - 1, HEIGHT - 1]

def dijkstra(grid)
  dist = Hash.new Float::INFINITY
  dist[START] = 0
  prev = {}
  heap = PairingHeap::MinPriorityQueue.new
  heap.push START, 0

  until heap.empty?
    u = heap.extract_min
    neighbors(u).each do |v|
      next if grid[u] == :byte
      alt = dist[u] + 1
      next unless alt < dist[v]
      prev[v] = u
      dist[v] = alt
      heap.push v, alt
    end
  end

  [dist, prev]
end

grid = grid_at(1024)

dist, prev = dijkstra(grid)

p dist[GOAL]

# p prev

def make_path(prev)
  path = Set.new
  u = GOAL
  return nil unless prev[u]
  while u
    path.add u
    u = prev[u]
  end

  path
end

path = make_path prev

BYTES[1024..].each do |byte|
  # puts "adding byte #{byte} at ns #{nanosecond}"
  grid[byte] = :byte
  next unless path.include? byte
  dist, prev = dijkstra(grid)
  # puts "goal reached in #{d[GOAL]}"
  break puts "#{byte[0]},#{byte[1]}" if dist[GOAL] == Float::INFINITY
  path = make_path prev
end
