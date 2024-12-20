#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'matrix'
require 'pairing_heap'

P = Vector

EMPTY = 1
WALL = 2

MAP = ARGF.readlines(chomp: true).flat_map.with_index { |row, y|
  row.chars.map.with_index { |cell, x|
    START = P[x, y] if cell == ?S
    GOAL = P[x, y] if cell == ?E
    [P[x, y], cell == ?# ? WALL : EMPTY]
  }
}.to_h.freeze

DIRS = [
  P[1, 0], # Right
  P[0, 1], # Down
  P[-1, 0], # Left
  P[0, -1] # Up
].freeze

def neighbors(pos)
  DIRS.map { [pos + _1, _1] }
end

def manhattan(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

def dijkstra_simple
  dist = Hash.new Float::INFINITY
  dist[START] = 0
  heap = PairingHeap::MinPriorityQueue.new
  heap.push START, 0
  prev = {}

  MAP.each do |pos, cell|
    next if cell != EMPTY
    next if pos == START
    heap.push pos, Float::INFINITY
  end

  until heap.empty?
    u = heap.extract_min
    neighbors(u).each do |v, _| # rubocop:disable Style/HashEachMethods
      next if MAP[v] == WALL
      alt = dist[u] + 1
      next unless alt < dist[v]
      prev[v] = u
      dist[v] = alt
      heap.decrease_key v, alt
    end
  end

  [dist, prev]
end

def make_path(prev)
  s = []
  u = GOAL
  until u.nil?
    s.unshift u
    u = prev[u]
  end
  s
end

DIST, PREV = dijkstra_simple
PATH = make_path(PREV)
PATH_SET = PATH.to_set
COST = DIST[GOAL]

def bfs_cheat
  queue = [[START, [START].to_set, 0, nil]]
  results = {}

  until queue.empty?
    pos, vis, cost, cheat = queue.shift
    next if cost > COST
    if pos == GOAL
      results[cheat] = cost
      next
    end
    neighbors(pos).each do |neighbor, dir|
      next if vis.include?(neighbor)
      n_vis = vis.dup
      n_vis.add neighbor
      if MAP[neighbor] == WALL
        next unless cheat.nil?
        c_pos = neighbor + dir
        next if vis.include? c_pos
        next unless MAP[c_pos] == EMPTY
        n_cheat = [neighbor, c_pos]
        if PATH_SET.include?(c_pos)
          results[n_cheat] = cost + 2 + DIST[GOAL] - DIST[c_pos]
        else
          queue.push [c_pos, n_vis, cost + 2, [neighbor, c_pos]]
        end
      else
        queue.push [neighbor, n_vis, cost + 1, cheat]
      end
    end
  end

  results
end

cheats = bfs_cheat

# grouped = {}

# cheats.each do |cheat, cost|
#   grouped[cost] ||= []
#   grouped[cost] << cheat
# end

# grouped.sort.reverse.each do |cost, cheats|
#   next if cost > COST
#   puts "There are #{cheats.size} cheats that save #{COST - cost} picoseconds."
# end

part1 = cheats.count { |_, cost| COST - cost >= 100 }

puts part1

combs = PATH.combination(2)

warn "#{combs.size} combinations"

to_try = combs.select { |a, b| manhattan(a, b) <= 20 }

warn "#{to_try.size} to try"

cheats2 = {}

to_try.each do |a, b|
  c_start, c_stop = DIST[a] > DIST[b] ? [b, a] : [a, b]
  id = [c_start, c_stop]
  dist_start_to_c_start = DIST[c_start]
  dist_c_stop_to_goal = DIST[GOAL] - DIST[c_stop]
  dist_cheat = manhattan(a, b)
  total_dist = dist_start_to_c_start + dist_c_stop_to_goal + dist_cheat
  cheats2[id] = total_dist
end

# grouped = {}
# cheats2.each do |cheat, cost|
#   grouped[cost] ||= []
#   grouped[cost] << cheat
# end

# grouped.sort.reverse.each do |cost, cheats|
#   puts "There are #{cheats.size} cheats that save #{COST - cost} picoseconds"
# end

part2 = cheats2.count { |_, cost| COST - cost >= 100 }

puts part2
