#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

# using an external gem for pairing heap
# I could use my own priority queue (in /lib/pqueue.rb), but it's quite a bit slower
require 'pairing_heap' # gem install pairing_heap

def cantor(x, y)
  ((x + y) * (x + y + 1)) / 2 + y
end

def cantor3(x, y, z)
  cantor(cantor(x, y), z)
end

# Using our own Point class instead of Vector speeds the code up by several
# seconds. Probably because this Point class is specialized for 2 fields only
# (x and y) whereas the Vector class is generalized to handle any number
# of fields.
class Point
  attr_reader :x, :y, :hash

  private def initialize(x, y)
    @x = x
    @y = y
    @hash = cantor(x, y)
  end

  def self.[](x, y) = Point.new x, y
  def +(other) = Point.new x + other.x, y + other.y
  def *(other) = Point.new x * other, y * other
  def ==(other) = hash == other.hash
  def eql?(other) = hash.eql? other.hash
end

GRID = Hash[ARGF.readlines(chomp: true).flat_map.with_index { |line, y|
  line.chars.map.with_index { |c, x| [Point[x, y], c.to_i] }
}].tap { _1.default = Float::INFINITY }

WIDTH = GRID.keys.map(&:x).max + 1
HEIGHT = GRID.keys.map(&:y).max + 1

START = Point[0, 0]
GOAL = Point[WIDTH - 1, HEIGHT - 1]

DIRS = [0, 1, 2, 3].freeze
OPPOSITES = [1, 0, 3, 2].freeze
DIR_TO_V = [Point[1, 0], Point[-1, 0], Point[0, 1], Point[0, -1]].freeze

def neighbors(current, last_dir, min, max)
  valid_dirs = DIRS - [last_dir, OPPOSITES[last_dir]]
  valid_dirs.flat_map { |dir|
    v = DIR_TO_V[dir]
    (min..max).map { |m|
      cost = 0
      m.times { |i| cost += GRID[current + v * (i + 1)] }
      [current + v * m, dir, cost]
    }
  }.reject { |p, _, _| p.x < 0 || p.x >= WIDTH || p.y < 0 || p.y >= HEIGHT }
end

def solve(source = START, target = GOAL, &neighbors)
  queue = PairingHeap::SimplePairingHeap.new
  queue.push [source, -1, 0], 0

  seen = Set.new

  until queue.empty?
    current, last_dir, cost = queue.pop
    next unless seen.add? cantor(current.hash, last_dir)
    return cost if current == target
    neighbors.call(current, last_dir).each do |np, d, c|
      queue.push [np, d, cost + c], cost + c
    end
  end
end

puts solve { neighbors(_1, _2, 1, 3) }
puts solve { neighbors(_1, _2, 4, 10) }
