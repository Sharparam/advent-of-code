#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'

PATH = ARGV.first || 'input'
DEBUG = ENV['DEBUG']

class Vector
  def x; self[0]; end
  def y; self[1]; end
end

grid = Hash.new 0
width = 0

File.readlines(PATH).map(&:strip).each_with_index do |line, y|
  width = line.size if line.size > width
  line.chars.each_with_index do |cell, x|
    grid[Vector[x, y]] = cell == '#' ? 1 : 0
  end
end

WIDTH = width

def adjacents(grid)
  Hash[grid.map do |pos, _|
    [
      pos,
      [
        pos + Vector[0, 1],
        pos + Vector[1, 0],
        pos + Vector[0, -1],
        pos + Vector[-1, 0]
      ].sum { |other| grid[other] }
    ]
  end]
end

def biodiv(obj)
  case obj
  when Vector
    2 ** (obj.y * WIDTH + obj.x)
  else
    obj.sum { |pos, tile| biodiv(pos) * tile }
  end
end

counts = Hash.new 0

hash = grid.hash
counts[hash] = 1

until counts[hash] > 1
  adj = adjacents grid
  grid.each do |pos, type|
    if type == 1 && adj[pos] != 1
      grid[pos] = 0
    elsif type == 0 && (adj[pos] == 1 || adj[pos] == 2)
      grid[pos] = 1
    end
  end
  hash = grid.hash
  counts[hash] += 1
end

puts "Part 1: #{biodiv grid}"

if DEBUG
  require 'pry'
  binding.pry
end
