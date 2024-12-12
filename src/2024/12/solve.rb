#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

GRID = ARGF.readlines(chomp: true).flat_map.with_index { |line, y|
  line.chars.map.with_index { |h, x| [Vector[x, y], h] }
}.to_h

DIRS = [Vector[1, 0], Vector[-1, 0], Vector[0, 1], Vector[0, -1]].freeze

def neighbors(pos)
  DIRS.map { pos + _1 }
end

queue = GRID.keys
seen = Set.new

regions = []

until queue.empty?
  pos = queue.shift
  next unless seen.add? pos
  plant = GRID[pos]

  region = { plant: plant, area: 0, perimeter: 0, edges: Set.new, sides: 0 }

  bfs = [pos]
  bfs_seen = Set.new

  until bfs.empty?
    current = bfs.shift
    next unless bfs_seen.add? current
    seen.add current
    region[:area] += 1
    around = neighbors(current).reject { |n| bfs_seen.include?(n) }
    around.each do |neighbor|
      if GRID[neighbor] == plant
        bfs.push neighbor
      else
        region[:perimeter] += 1
        region[:edges] << current
      end
    end
  end

  regions << region
end

puts regions.sum { _1[:area] * _1[:perimeter] }

regions.each do |region|
  plant = region[:plant]
  areas = DIRS.to_h { [_1, {}] }
  DIRS.each do |direction|
    region[:edges].each do |edge|
      neighbor = edge + direction
      areas[direction][neighbor] = '#' unless GRID[neighbor] == plant
    end
  end
  areas.each_value do |area|
    distinct = 0
    seen = Set.new
    queue = area.keys
    until queue.empty?
      pos = queue.shift
      next unless seen.add? pos
      bfs = [pos]
      bfs_seen = Set.new
      until bfs.empty?
        current = bfs.shift
        next unless bfs_seen.add? current
        seen.add current
        around = neighbors(current).reject { |n| bfs_seen.include?(n) || area[n] != '#' }
        around.each do |neighbor|
          bfs.push neighbor
        end
      end
      distinct += 1
    end
    region[:sides] += distinct
  end
end

puts regions.sum { _1[:area] * _1[:sides] }
