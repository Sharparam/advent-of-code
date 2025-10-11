#!/usr/bin/env ruby
# frozen_string_literal: true

TYPES = { ?L => :empty, ?. => :floor, ?# => :occupied }.freeze
SEATS = ARGF.readlines.map { |l| l.chomp.chars.map { TYPES[_1] } }

def count_occupied(grid, x, y)
  (y - 1..y + 1).flat_map { |y1|
    (x - 1..x + 1).map { |x1| [x1, y1] }
  }.reject { |x1, y1|
    (x1 == x && y1 == y) || x1 < 0 || y1 < 0
  }.count { |x1, y1| (grid[y1] || [])[x1] == :occupied }
end

def locate(grid, x, y, dir)
  return nil if x < 0 || y < 0 || y >= grid.size
  row = grid[y]
  return nil if x >= row.size
  return row[x] unless row[x] == :floor
  locate grid, x + dir[0], y + dir[1], dir
end

def count_occupied2(grid, x, y)
  (y - 1..y + 1).flat_map { |y1|
    (x - 1..x + 1).map { |x1| [x1, y1] }
  }.reject { |x1, y1|
    (x1 == x && y1 == y) || x1 < 0 || y1 < 0
  }.count { |x1, y1| locate(grid, x1, y1, [x1 - x, y1 - y]) == :occupied }
end

def copy(grid)
  grid.map(&:dup)
end

def transform(grid, threshold, &counter)
  newgrid = copy grid
  (0...grid.size).each do |y|
    (0...grid[y].size).each do |x|
      occupied = counter.call(grid, x, y)
      if grid[y][x] == :empty && occupied == 0
        newgrid[y][x] = :occupied
      elsif grid[y][x] == :occupied && occupied >= threshold
        newgrid[y][x] = :empty
      end
    end
  end
  newgrid
end

def solve(threshold, &counter)
  seats_copy = copy SEATS

  loop do
    hashed = seats_copy.hash
    seats_copy = transform seats_copy, threshold, &counter
    break if hashed == seats_copy.hash
  end

  puts seats_copy.sum { |r| r.count(:occupied) }
end

solve 4, &method(:count_occupied)
solve 5, &method(:count_occupied2)
