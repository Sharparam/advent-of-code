#!/usr/bin/env ruby

require 'colorize'
require 'matrix'
require 'set'

DEBUG = ENV['DEBUG']

PATH = ARGV.first || 'input'

INPUT_MAP = {
  '#' => :wall,
  ' ' => :empty,
  '.' => :open
}

OUTPUT_MAP = {
  wall: '██'.white,
  open: '  '.black,
  empty: '  '.black,
  dead: '██'.red
}

TRANSFORMS = {
  north: Vector[0, -1],
  south: Vector[0, 1],
  west: Vector[-1, 0],
  east: Vector[1, 0]
}

class Vector
  def x; self[0]; end
  def y; self[1]; end
end

module Enumerable
  def tally
    Hash.new(0).tap { |h| self.each { |v| h[v] += 1 } }
  end
end

class Maze
  attr_reader :grid, :teleporters

  def initialize(grid)
    @grid = grid
    xs = @grid.keys.map(&:x)
    ys = @grid.keys.map(&:y)
    @min_x = xs.min
    @max_x = xs.max
    @min_y = ys.min
    @max_y = ys.max
    process!
  end

  def self.from_file(path)
    letters = {}
    grid = Hash.new :empty
    File.readlines(path).each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        pos = Vector[x, y]
        case char
        when ' '
          grid[pos] = :empty
        when '#'
          grid[pos] = :wall
        when '.'
          grid[pos] = :open
        else
          letters[pos] = char
        end
      end
    end

    letters.each do |(pos, letter)|
      if grid[pos + TRANSFORMS[:north]] == :open
        other = letters[pos + TRANSFORMS[:south]]
        label = letter + other
        grid[pos] = label
      elsif grid[pos + TRANSFORMS[:south]] == :open
        other = letters[pos + TRANSFORMS[:north]]
        label = other + letter
        grid[pos] = label
      elsif grid[pos + TRANSFORMS[:west]] == :open
        other = letters[pos + TRANSFORMS[:east]]
        label = letter + other
        grid[pos] = label
      elsif grid[pos + TRANSFORMS[:east]] == :open
        other = letters[pos + TRANSFORMS[:west]]
        label = other + letter
        grid[pos] = label
      end
    end

    Maze.new grid
  end

  def process!
    @teleporters = {}

    @grid.each do |(pos, tile)|
      if deadend? pos
        fill_deadends! pos
      elsif tile == 'AA'
        others = surroundings pos
        @start_pos = others.find { |(_, t)| t == :open }.first
      elsif tile == 'ZZ'
        others = surroundings pos
        @finish_pos = others.find { |(_, t)| t == :open }.first
      elsif tile =~ /\A[A-Z]{2}\z/
        @teleporters[tile] ||= []
        points = @teleporters[tile]
        unless points.include? pos
          others_here = surroundings pos
          open_pos, _ = others_here.find { |(_, tile)| tile == :open }
          points << open_pos
        end
      end
    end

    @grid.keys.each do |pos|
      @grid[pos] = :wall if @grid[pos] == :dead
    end
  end

  def draw
    (@min_y..@max_y).each do |y|
      (@min_x..@max_x).each do |x|
        pos = Vector[x, y]
        tile = @grid[pos]
        sprite = OUTPUT_MAP[tile] || tile
        if tile == 'AA'
          print sprite.black.on_blue
        elsif tile == 'ZZ'
          print sprite.black.on_green
        else
          print sprite
        end
      end
      puts
    end
  end

  def shortest_path(pos = nil, previous_pos = nil, steps = 0, ports = Set.new)
    pos = @start_pos unless pos
    return steps if pos == @finish_pos

    others = surroundings(pos).select { |_, t| t != :wall }.reject do |p, t|
      p == previous_pos || ports.include?(t) || t == 'AA' || t == 'ZZ'
    end

    return nil if others.empty?

    costs = others.map do |target_pos, target_tile|
      if target_tile == :open
        shortest_path(target_pos, pos, steps + 1, ports.dup)
      else # It's a teleporter
        tp_pos = @teleporters[target_tile].reject { |p| p == pos }[0]
        ports.add target_tile
        shortest_path(tp_pos, pos, steps + 1, ports.dup)
      end
    end

    costs.compact.min
  end

  private

  def fill_deadends!(pos)
    return unless @grid[pos] == :open
    @grid[pos] = :dead
    others = surroundings pos

    others.keys.each do |other_pos|
      fill_deadends! other_pos if deadend?(other_pos) && @grid[other_pos] != :dead
    end
  end

  def deadend?(pos)
    tile = @grid[pos]
    return false if tile == :wall
    return true if tile == :dead
    return false unless tile == :open
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

maze = Maze.from_file PATH

maze.draw if DEBUG

part1 = maze.shortest_path

puts "Part 1: #{part1}"

if DEBUG
  require 'pry'
  binding.pry
end
