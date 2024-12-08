#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Vector; def x = self[0]; def y = self[1]; end

def dist(a, b) = (a.x - b.x).abs + (a.y - b.y).abs

antennas = Hash.new { _1[_2] = [] }

# grid = {}

lines = ARGF.readlines

HEIGHT = lines.size

lines.each_with_index do |line, y|
  row = line.chomp.chars
  WIDTH ||= row.size
  row.each_with_index do |col, x|
    next if col == ?.
    antennas[col.to_sym] << Vector[x, y]
    # grid[Vector[x, y]] = col.to_sym
  end
end

antinodes = Set.new
antinodes_2 = Set.new

antennas.each do |freq, nodes|
  pairs = nodes.combination(2)
  pairs.each do |a, b|
    antinodes_2.add a
    antinodes_2.add b
    if a.x == b.x
      top, bottom = [a.y, b.y].minmax
      d_y = bottom - top
      antinodes.add Vector[a.x, top - d_y] unless top - d_y < 0
      antinodes.add Vector[a.x, bottom + d_y] unless top + d_y >= HEIGHT
      y = top - d_y
      while y >= 0
        antinodes_2.add Vector[a.x, y]
        y -= d_y
      end
      y = bottom + d_y
      while y < HEIGHT
        antinodes_2.add Vector[a.x, y]
        y += d_y
      end
    elsif a.y == b.y
      left, right = [a.x, b.x].minmax
      d_x = right - left
      antinodes.add Vector[left - d_x, a.y] unless left - d_x < 0
      antinodes.add Vector[right + d_x, a.y] unless right + d_x >= WIDTH
      x = left - d_x
      while x >= 0
        antinodes_2.add Vector[x, a.y]
        x -= d_x
      end
      x = right + d_x
      while x < WIDTH
        antinodes_2.add Vector[x, a.y]
        x += d_x
      end
    else # diagonal
      d = Vector[(a.x - b.x).abs, (a.y - b.y).abs]
      if a.x < b.x && a.y < b.y # a is top left
        antinodes.add a - d unless a.x - d.x < 0 || a.y - d.y < 0
        antinodes.add b + d unless b.x + d.x >= WIDTH || b.y + d.y >= HEIGHT
        n = a - d
        while n.x >= 0 && n.y >= 0
          antinodes_2.add n
          n -= d
        end
        n = b + d
        while n.x < WIDTH && n.y < HEIGHT
          antinodes_2.add n
          n += d
        end
      elsif a.x > b.x && a.y < b.y # a is top right
        antinodes.add Vector[a.x + d.x, a.y - d.y] unless a.x + d.x >= WIDTH || a.y - d.y < 0
        antinodes.add Vector[b.x - d.x, b.y + d.y] unless b.x - d.x < 0 || b.y + d.y >= HEIGHT
        n_d = Vector[d.x, -d.y]
        n = a + n_d
        while n.x < WIDTH && n.y >= 0
          antinodes_2.add n
          n += n_d
        end
        n_d = Vector[-d.x, d.y]
        n = b + n_d
        while n.x >= 0 && n.y < HEIGHT
          antinodes_2.add n
          n += n_d
        end
      elsif a.x < b.x && a.y > b.y # a is bottom left
        antinodes.add Vector[a.x - d.x, a.y + d.y] unless a.x - d.x < 0 || a.y + d.y >= HEIGHT
        antinodes.add Vector[b.x + d.x, b.y - d.y] unless b.x + d.x >= WIDTH || b.y - d.y < 0
        n_d = Vector[-d.x, d.y]
        n = a + n_d
        while n.x >= 0 && n.y < HEIGHT
          antinodes_2.add n
          n += n_d
        end
        n_d = Vector[d.x, -d.y]
        n = b + n_d
        while n.x < WIDTH && n.x >= 0
          antinodes_2.add n
          n += n_d
        end
      else # a is bottom right
        antinodes.add a + d unless a.x + d.x >= WIDTH || a.y + d.y >= HEIGHT
        antinodes.add b - d unless b.x - d.x < 0 || b.y - d.y < 0
        n = a + d
        while n.x < WIDTH && n.y < HEIGHT
          antinodes_2.add n
          n += d
        end
        n = b - d
        while n.x >= 0 && n.y >= 0
          antinodes_2.add n
          n -= d
        end
      end
    end
  end
end

# HEIGHT.times do |y|
#   WIDTH.times do |x|
#     pos = Vector[x, y]
#     if antinodes.include? pos
#       print '#'
#     elsif grid.key? pos
#       print grid[pos].to_s
#     else
#       print '.'
#     end
#   end
#   puts
# end

puts antinodes.size
puts antinodes_2.size
