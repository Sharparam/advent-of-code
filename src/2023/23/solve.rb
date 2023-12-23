#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def cantor(x, y)
  ((x + y) * (x + y + 1)) / 2 + y
end

class Point
  attr_reader :x, :y, :hash

  def initialize(x, y)
    @x, @y = x, y
    @hash = cantor x, y
  end

  def self.[](x, y)
    Point.new x, y
  end

  def ==(other)
    hash == other.hash
  end
  alias_method :eql?, :==

  def +(other)
    Point.new x + other.x, y + other.y
  end

  def *(n)
    Point.new x * n, y * n
  end

  def to_s
    "(#{x}, #{y})"
  end
  alias_method :inspect, :to_s
end

class Graph
  def initialize
    @edges = Hash.new { |h, k| h[k] = Hash.new(0) }
  end

  def add_edge(source, dest, weight)
    @edges[source][dest] = weight
  end

  def remove_edge(source, dest)
    @edges[source].delete(dest)
  end

  def has_edge?(source, dest)
    @edges.key?(source) && @edges[source].key?(dest)
  end

  def has_source?(source)
    @edges.key?(source)
  end

  def cost(source, dest)
    @edges[source][dest]
  end

  def neighbors(source)
    @edges[source].keys
  end

  def find_sources(dest)
    @edges.flat_map { |s, h| h.keys.map { |d| [d, s] } }.select { |d, s| d == dest }.map(&:last)
  end

  def debug
    @edges.each do |source, dests|
      puts "#{source} leads to"
      dests.each do |dest, cost|
        puts "  #{dest} with cost #{cost}"
      end
    end
  end
end

SLOPES = { ?^ => Point[0, -1], ?> => Point[1, 0], ?v => Point[0, 1], ?< => Point[-1, 0] }.freeze
DIRS = SLOPES.values.freeze

GRID = ARGF.readlines(chomp: true).map(&:chars)

HEIGHT = GRID.size
WIDTH = GRID[0].size

START = Point[GRID[0].index(?.), 0]
GOAL = Point[GRID[HEIGHT - 1].index(?.), HEIGHT - 1]

def neighbors(pos)
  c = GRID[pos.y][pos.x]
  if c == ?.
    return DIRS.map { |d| pos + d }.reject { |p| p.x < 0 || p.x >= WIDTH || p.y < 0 || p.y >= HEIGHT || GRID[p.y][p.x] == ?# }
  end

  return [pos + SLOPES[c]].reject { |p| p.x < 0 || p.x >= HEIGHT || p.y < 0 || p.y >= HEIGHT || GRID[p.y][p.x] == ?# }
end

def neighbors_2(pos)
  DIRS.map { |d| pos + d }.reject { |p| p.x < 0 || p.x >= WIDTH || p.y < 0 || p.y >= HEIGHT || GRID[p.y][p.x] == ?# }
end

def bfs(&neighbors)
  queue = [[START, Set.new([START]), 0]]
  max = 0

  until queue.empty?
    current, seen, cost = queue.shift
    if current == GOAL
      max = cost if cost > max
      next
    end
    n = neighbors.call(current).reject { |p| seen.include?(p) }
    n.each do |pos|
      n_seen = seen.dup
      n_seen.add pos
      queue.push [pos, n_seen, cost + 1]
    end
  end

  max
end

def bfs2(graph)
  queue = [[START.hash, Set.new, 0]]
  max = 0
  goal = GOAL.hash

  until queue.empty?
    current, seen, cost = queue.shift
    seen.add current
    if current == goal
      max = cost if cost > max
      next
    end
    graph.neighbors(current).each do |pos|
      next if seen.include?(pos)
      queue.push [pos, seen.dup, cost + graph.cost(current, pos)]
    end
  end

  max
end

def compress(debug = false, &neighbors)
  queue = [[START, Set.new]]
  graph = Graph.new

  inters =  Set.new

  until queue.empty?
    current, seen = queue.pop
    next if current == GOAL
    seen.add current
    cost = 0
    poses = neighbors.call(current).reject { |p| seen.include?(p) }
    if poses.empty?
      puts "dead end, giving up" if debug
      next
    end
    last = current
    before_inter = last
    puts "Processing #{current} with neighbors: #{poses}" if debug
    while poses.size == 1
      cost += 1
      before_inter = last
      last = poses[0]
      seen.add last
      poses = neighbors.call(last).reject { |p| seen.include?(p) }
    end
    puts "  intersection at #{last}" if debug
    if (current == last || poses.empty?) && last != GOAL
      puts "  dead end, giving up (last was #{last} at cost #{cost})" if debug
      next
    end
    puts "  path from #{current} to #{last} with cost #{cost}" if debug
    graph.add_edge(current.hash, last.hash, cost) if cost > graph.cost(current.hash, last.hash)
    next if last == GOAL
    poses.each do |pos|
      if inters.add?([last, pos])
        puts "  Exploring #{last} -> #{pos}" if debug
      else
        puts "  Not exploring #{last} -> #{pos} because already traveled" if debug
        next
      end
      n_seen = Set.new [last, before_inter]
      others = poses.reject { |p| p == pos }
      others.each { |p| n_seen.add p }
      queue.push [last, n_seen]
    end
  end

  graph
end

puts bfs(&method(:neighbors))

graph = compress(&method(:neighbors_2))

goal = GOAL.hash

# Optimize the final intersection before the goal
# so that the only possible path is to the goal
# Taking any other path at the final intersection will make it impossible
# to reach the goal because it will be blocked.
source = graph.find_sources(goal)[0]
(graph.neighbors(source) - [goal]).each { |dest| graph.remove_edge(source, dest) }

puts bfs2(graph)
