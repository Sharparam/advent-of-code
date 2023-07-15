#!/usr/bin/env ruby

require 'matrix'

require 'pry'

PATH = ARGV.first || 'input'
STEPS = ARGV[1]&.to_i || 200
DEBUG = ENV['DEBUG']
WIDTH = 5
HEIGHT = 5
SIZE = WIDTH * HEIGHT

def makegrid
  [0] * SIZE
end

def makeind(x, y)
  x + y * WIDTH
end

def drawgrid(grid)
  (0...HEIGHT).each do |y|
    (0...WIDTH).each do |x|
      if y == 2 && x == 2
        print '?'
      else
        print grid[makeind(x, y)] == 1 ? '#' : '.'
      end
    end
    puts
  end
end

def drawadj(adj)
  (0...HEIGHT).each do |y|
    (0...WIDTH).each do |x|
      print adj[makeind(x, y)]
    end
    puts
  end
end

def draw(grid, adj)
  (0...HEIGHT).each do |y|
    (0...WIDTH).each do |x|
      if y == 2 && x == 2
        print '?'
      else
        print grid[makeind(x, y)] == 1 ? '#' : '.'
      end
    end
    print ' '
    (0...WIDTH).each do |x|
      print adj[makeind(x, y)]
    end
    puts
  end
end

def adjacents(grids)
  levels = grids.keys
  result = {}

  levels.each do |level|
    grid = grids[level]
    adj = makegrid
    result[level] = adj
    (0...WIDTH).each do |x|
      (0...HEIGHT).each do |y|
        if x == 2 && y == 2
          adj[makeind(x, y)] = '?'
        else
          has_up = grids.key? level - 1
          has_down = grids.key? level + 1
          up = grids[level - 1]
          down = grids[level + 1]
          top = grid[makeind(x, y - 1)] || 0
          left = grid[makeind(x - 1, y)] || 0
          right = grid[makeind(x + 1, y)] || 0
          bottom = grid[makeind(x, y + 1)] || 0

          if x == 0 && up # Left edge, go up a level for `left`
            left = up[makeind(1, 2)]
          elsif x == 4 && up # Right edge, go up a level for `right`
            right = up[makeind(3, 2)]
          elsif x == 1 && y == 2 && down # Right side is down a level
            right = (0...HEIGHT).sum { |dy| down[makeind(0, dy)] }
          elsif x == 3 && y == 2 && down # Left side is down a level
            left = (0...HEIGHT).sum { |dy| down[makeind(4, dy)] }
          end

          if y == 0 && up # Top edge, go up a level for `top`
            top = up[makeind(2, 1)]
          elsif y == 4 && up # Bottom edge, go up a level for `bottom`
            bottom = up[makeind(2, 3)]
          elsif y == 1 && x == 2 && down # Bottom side is down a level
            bottom = (0...WIDTH).sum { |dx| down[makeind(dx, 0)] }
          elsif y == 3 && x == 2 && down # Top side is down a level
            top = (0...WIDTH).sum { |dx| down[makeind(dx, 4)] }
          end

          adj[makeind(x, y)] = top + left + right + bottom
        end
      end
    end
  end

  result
end

def step(grids)
  levels = grids.keys.sort
  min_level = levels.min
  max_level = levels.max
  adjs = adjacents grids

  levels.each do |level|
    grid = grids[level]
    adj = adjs[level]

    if level == min_level
      up = grids[min_level - 1]
      left_count = (0...HEIGHT).sum { |y| grid[makeind(0, y)] }
      right_count = (0...HEIGHT).sum { |y| grid[makeind(4, y)] }
      top_count = (0...WIDTH).sum { |x| grid[makeind(x, 0)] }
      bottom_count = (0...WIDTH).sum { |x| grid[makeind(x, 4)] }
      up[makeind(1, 2)] = 1 if left_count == 1 || left_count == 2
      up[makeind(3, 2)] = 1 if right_count == 1 || right_count == 2
      up[makeind(2, 1)] = 1 if top_count == 1 || top_count == 2
      up[makeind(2, 3)] = 1 if bottom_count == 1 || bottom_count == 2
    elsif level == max_level
      down = grids[max_level + 1]
      if grid[makeind(2, 1)] == 1
        (0...WIDTH).each { |x| down[makeind(x, 0)] = 1 }
      end

      if grid[makeind(1, 2)] == 1
        (0...HEIGHT).each { |y| down[makeind(0, y)] = 1 }
      end

      if grid[makeind(3, 2)] == 1
        (0...HEIGHT).each { |y| down[makeind(4, y)] = 1 }
      end

      if grid[makeind(2, 3)] == 1
        (0...WIDTH).each { |x| down[makeind(x, 4)] = 1 }
      end
    end

    (0...WIDTH).each do |x|
      (0...HEIGHT).each do |y|
        ind = makeind x, y
        if x == 2 && y == 2
          grid[ind] = 0
        else
          type = grid[ind]
          count = adj[ind]
          if type == 1 && count != 1
            grid[ind] = 0
          elsif type == 0 && (count == 1 || count == 2)
            grid[ind] = 1
          end
        end
      end
    end

    if DEBUG
      puts "Depth #{level}:"
      draw grid, adj
      puts
    end
  end
end

grids = Hash.new { |h, k| h[k] = makegrid }
grids[-1] = makegrid
grids[0] = makegrid
grids[1] = makegrid

File.readlines(PATH).map(&:strip).each_with_index do |line, y|
  line.chars.each_with_index do |cell, x|
    grids[0][makeind(x, y)] = cell == '#' ? 1 : 0
  end
end

STEPS.times do |i|
  puts "Minute #{i + 1}:" if DEBUG
  step grids
end

count = grids.sum { |_, grid| grid.sum }

puts "Part 2: #{count}"

if DEBUG
  require 'pry'
  binding.pry
end
