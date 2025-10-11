#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

GRID = ARGF.readlines(chomp: true).flat_map.with_index { |line, y|
  line.chars.map.with_index { |h, x| [Vector[x, y], h.to_i] }
}.to_h.tap { _1.default = Float::INFINITY }

DIRS = [Vector[1, 0], Vector[-1, 0], Vector[0, 1], Vector[0, -1]].freeze

$cache = {}

def neighbors(current)
  $cache[current] ||= DIRS.map { current + _1 }.select { GRID[_1] - GRID[current] == 1 }
end

puts GRID.filter_map { _2.zero? ? _1 : nil }.map { |start|
  queue = [start]
  seen = Set.new
  score = 0
  rating = 0

  until queue.empty?
    current = queue.pop
    if GRID[current] == 9
      score += 1 if seen.add? current
      rating += 1
    end
    neighbors(current).each { queue.push _1 }
  end

  [score, rating]
}.transpose.map { _1.reduce(:+) }
