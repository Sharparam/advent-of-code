#!/usr/bin/env ruby
# frozen_string_literal: true

require 'colorize'
require 'matrix'

require 'io/console'

DEBUG = ENV['DEBUG']
PATH = ARGV.first || 'input'

INPUT_MAP = {
  '#' => :wall,
  '.' => :open,
  '@' => :current
}

OUTPUT_MAP = {
  :wall => '██',
  :open => '  ',
  :current => '██'.green,
  :dead => '██'.red
}

TRANSFORMS = {
  north: Vector[0, -1],
  south: Vector[0, 1],
  west: Vector[-1, 0],
  east: Vector[1, 0]
}

TRANSFORM_MAP = {
  'd' => :east,
  'a' => :west,
  'w' => :north,
  's' => :south
}

def term_clear; print "\e[H"; end

class Vector
  def x; self[0]; end
  def y; self[1]; end
end

class String
  def lower?
    return false if self.size != 1
    self =~ /[[:lower:]]/
  end

  def upper?
    return false if self.size != 1
    self =~ /[[:upper:]]/
  end
end

module Enumerable
  def tally
    Hash.new(0).tap { |h| self.each { |v| h[v] += 1 } }
  end
end

class Map
  attr_reader :grid, :keys, :doors, :current_pos

  def initialize(grid)
    @grid = grid
    @grid.default = :wall
    @keys = {}
    @doors = {}
    @top = 0
    @left = 0
    @bottom = grid.keys.map(&:y).max
    @right = grid.keys.map(&:x).max
    @current_pos = Vector[0, 0]
    @move_count = 0
    process!
  end

  def self.from_file(path)
    grid = {}
    File.readlines(path).map(&:strip).each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        grid[Vector[x, y]] = INPUT_MAP[char] || char
      end
    end
    Map.new grid
  end

  def process!
    @grid.keys.each do |pos|
      tile = @grid[pos]
      if deadend? pos
        fill_deadends! pos
      elsif tile == :current
        @current_pos = pos
        @grid[pos] = :open
      elsif tile.is_a? String
        if tile.upper?
          @doors[tile] = pos
        elsif tile.lower?
          @keys[tile] = pos
        end
      end
    end

    @grid.keys.each do |pos|
      @grid[pos] = :wall if @grid[pos] == :dead
    end
  end

  def collect_key!(key)
    @grid[@keys.delete key] = :open
    @grid[@doors.delete key.upcase] = :open
    process!
  end

  def move!(direction)
    new_pos = @current_pos + TRANSFORMS[direction]
    new_tile = @grid[new_pos]
    return if new_tile == :wall
    return if new_tile.is_a?(String) && new_tile.upper?
    @current_pos = new_pos

    if new_tile.is_a?(String) && new_tile.lower?
      collect_key! new_tile
    end

    process!
  end

  def draw
    #term_clear unless DEBUG
    buffer = ''
    (0..@bottom).each do |y|
      (0..@right).each do |x|
        tile = @grid[Vector[x, y]]
        pos = Vector[x, y]
        if @current_pos == pos
          buffer += OUTPUT_MAP[:current]
        elsif OUTPUT_MAP[tile]
          buffer += OUTPUT_MAP[tile]
        elsif tile.upper?
          buffer += tile.rjust(2).black.on_yellow
        else
          buffer += tile.rjust(2).black.on_blue
        end
      end
      buffer += "\n"
    end
    puts buffer
  end

  private

  def fill_deadends!(pos)
    return if @grid[pos] == :wall || pos == @current_pos
    @grid[pos] = :dead
    others = surroundings pos

    others.keys.each do |other_pos|
      fill_deadends! other_pos if deadend?(other_pos) && @grid[other_pos] != :dead
    end
  end

  def deadend?(pos)
    return false if pos == @current_pos
    tile = @grid[pos]
    return false if tile == :wall
    return true if tile == :dead
    return false if tile.is_a?(String) && tile.lower?
    others = surroundings pos
    counts = others.values.tally
    (counts[:wall] + counts[:dead]) >= 3
  end

  def surroundings(pos)
    other_pos = [
      pos + TRANSFORMS[:north],
      pos + TRANSFORMS[:south],
      pos + TRANSFORMS[:west],
      pos + TRANSFORMS[:east]
    ]

    Hash[ other_pos.map { |p| [p, @grid[p]] } ]
  end
end

map = Map.from_file PATH

map.draw

#while (input = STDIN.getch) != 'q'
#  char = input[0].downcase
#  direction = TRANSFORM_MAP[char]
#  map.move! direction
#  map.draw
#end

if DEBUG
  require 'pry'
  binding.pry
end
