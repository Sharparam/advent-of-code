#!/usr/bin/env ruby
# frozen_string_literal: true

require 'colorize'
require 'matrix'

require_relative '../../intcode/cpu'

DEBUG = ENV['DEBUG']

class Vector
  def x; self[0]; end
  def y; self[1]; end
end

def term_clear
  print "\e[H"
end

def term_setpos(x, y)
  print "\e[#{y},#{x}H"
end

PATH = 'input'
DRAW = ARGV.size > 0

ORIGIN = Vector[0, 0]

DIRECTIONS = {
  north: 1,
  south: 2,
  west: 3,
  east: 4
}

TRANSFORMS = {
  north: Vector[0, -1],
  south: Vector[0, 1],
  west: Vector[-1, 0],
  east: Vector[1, 0]
}

STATUSES = {
  0 => :wall,
  1 => :empty,
  2 => :oxygen
}

TILES = {
  wall: '#',
  oxygen: 'O',
  empty: '.',
  droid: 'D',
  unknown: ' '
}

SIMPLE_TILES = {
  origin: '██'.magenta,
  wall: '██',
  oxygen: '██'.green,
  empty: '  ',
  droid: 'DD',
  deadend: '██'.red,
  deadpath: '██'.yellow,
  path: '██'.light_black,
  unknown: '██'
}

grid = Hash.new :unknown

def set_status(text)
  Curses.setpos 0, 0
  Curses.clrtoeol
  Curses.addstr text
end

class Bot
  attr_reader :position

  def initialize(cpu, position = Vector[0, 0])
    @cpu = cpu
    @position = position
    @active = true
  end

  def dup
    Bot.new @cpu.dup, @position
  end

  def move!(direction)
    return unless @active
    value = DIRECTIONS[direction]
    @cpu.input! value
    @cpu.run!
    status = STATUSES[@cpu.output[-1]]
    @cpu.clear_output!
    @position += TRANSFORMS[direction]
    @active = false if status == :wall
    status
  end

  def active?
    @active
  end

  def kill!
    @active = false
  end
end

Bounds = Struct.new :top, :bottom, :left, :right, :offset

class Map
  attr_reader :oxygen_position
  attr_reader :oxygen_distance
  attr_reader :fill_time

  def initialize(base_cpu)
    @base_cpu = base_cpu
    @grid = Hash.new :unknown
    @bots = Set.new
    first_bot = Bot.new base_cpu.dup
    @bots.add first_bot
  end

  def step!
    new_bots = []
    deleted_bots = []
    @bots.each do |bot|
      DIRECTIONS.keys.each do |direction|
        clone = bot.dup
        status = clone.move! direction

        if @grid[clone.position] == :unknown
          @grid[clone.position] = status
          new_bots << clone unless status == :wall
        end
      end

      deleted_bots << bot
    end

    @bots.subtract deleted_bots
    @bots.merge new_bots

    draw_simple
  end

  def process!
    empty_poses = @grid.select { |_, v| v == :empty }.map(&:first)

    empty_poses.each do |pos|
      if pos == ORIGIN
        @grid[pos] = :origin
      elsif deadend? pos
        @grid[pos] = :deadend
      end
    end

    draw_simple

    # Calculate deadend paths
    deadends = @grid.select { |_, v| v == :deadend }.map(&:first)
    deadends.each do |de|
      process_deadend! de
      draw_simple
    end

    path_cells = @grid.select { |_, v| v == :empty }.map(&:first)
    path_cells.each do |pos|
      @grid[pos] = :path
    end

    @oxygen_position = calc_oxygen_position
    @oxygen_distance = calc_oxygen_distance
    @processed = true
    fill!
  end

  def fill!
    process! unless @processed

    time = process_fill! @oxygen_position, 0
    draw_simple

    @fill_time = time
  end

  def process_deadend!(pos)
    others = surroundings pos
    return if others[:empty] > 1
    @grid[pos] = :deadpath if @grid[pos] == :empty

    dirs = [
      pos + TRANSFORMS[:north],
      pos + TRANSFORMS[:south],
      pos + TRANSFORMS[:west],
      pos + TRANSFORMS[:east]
    ]

    pos = dirs.find { |p| @grid[p] == :empty }
    process_deadend! pos
  end

  def process_fill!(pos, time)
    return time if @grid[pos] == :wall
    return time if @grid[pos] == :oxygen && pos != @oxygen_position
    others = surroundings pos
    @grid[pos] = :oxygen
    return time if others[:oxygen] + others[:wall] == 4

    draw_simple

    dirs = [
      pos + TRANSFORMS[:north],
      pos + TRANSFORMS[:south],
      pos + TRANSFORMS[:west],
      pos + TRANSFORMS[:east]
    ]

    dirs.map { |dir| process_fill! dir, time + 1 }.max
  end

  def done?
    @bots.size == 0
  end

  def calc_oxygen_position
    @grid.find { |_, v| v == :oxygen }.first
  end

  def calc_oxygen_distance
    @grid.count { |_, v| v == :path } + 1
  end

  def draw_simple(only_if_debug = true)
    return unless DRAW
    return if only_if_debug && !DEBUG
    term_clear
    bounds = calc_bounds
    (bounds.top..bounds.bottom).each do |y|
      (bounds.left..bounds.right).each do |x|
        pos = Vector[x, y]
        type = @grid[pos]
        print SIMPLE_TILES[type]
      end
      puts
    end
  end

  private

  def surroundings(pos)
    others = [
      @grid[pos + TRANSFORMS[:north]],
      @grid[pos + TRANSFORMS[:south]],
      @grid[pos + TRANSFORMS[:west]],
      @grid[pos + TRANSFORMS[:east]]
    ]

    Hash.new(0).tap { |h| others.each { |t| h[t] += 1 } }
  end

  def calc_bounds
    xs = @grid.keys.map(&:x)
    ys = @grid.keys.map(&:y)
    min_x = xs.min
    max_x = xs.max
    min_y = ys.min
    max_y = ys.max
    x_offset = min_x < 0 ? min_x.abs : 0
    y_offset = min_y < 0 ? min_y.abs : 0
    Bounds.new min_y, max_y, min_x, max_x, Vector[x_offset, y_offset]
  end

  def deadend?(pos)
    surroundings(pos)[:wall] == 3
  end
end

base_cpu = Intcode::CPU.new.load!(PATH).print_output!(false)

bots = Set.new
cpus = Set.new

bots.add Bot.new base_cpu.dup

map = Map.new base_cpu

until map.done?
  map.step!
end

map.process!
map.draw_simple(false)

puts "Part 1: #{map.oxygen_distance}"
puts "Part 2: #{map.fill_time}"
