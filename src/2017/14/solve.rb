#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../10/part2'

input = ARGV[1] || 'ffayrhll'

grid = (0..127).map { |n| knot_hash("#{input}-#{n}").hex.to_s(2).rjust(128, '0').chars.map { |b| b == '1' ? '#' : '.' } }

puts grid.sum { |r| r.count '#' }

def neighbours(coord, grid, visited)
  x, y = coord
  [
    [x - 1, y],
    [x + 1, y],
    [x, y - 1],
    [x, y + 1]
  ].reject { |c| visited.include?(c) || c[0] < 0 || c[0] > 127 || c[1] < 0 || c[1] > 127 || grid[y][x] == '.' }
end

visited = Set.new
coords = (0..127).flat_map { |x| (0..127).map { |y| [x, y] } }
regions = 0

coords.each do |coord|
  next if visited.include? coord
  visited.add coord

  to_visit = neighbours(coord, grid, visited)
  while to_visit.any?
    neighbour = to_visit.pop
    visited.add neighbour
    to_visit.push(*neighbours(neighbour, grid, visited))
  end

  regions += 1 if grid[coord[1]][coord[0]] == '#'
end

puts regions
