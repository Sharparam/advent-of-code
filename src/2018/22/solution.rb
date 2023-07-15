#!/usr/bin/env ruby

require 'matrix'

class Vector
  def x; self[0]; end
  def y; self[1]; end
end

class Region
  EROSION_MOD = 20183

  TYPE_MAP = {
    0 => :rocky,
    1 => :wet,
    2 => :narrow
  }.freeze

  RISK_LEVELS = {
    rocky: 0,
    wet: 1,
    narrow: 2
  }.freeze

  DISPLAY_MAP = {
    rocky: '.',
    wet: '=',
    narrow: '|'
  }.freeze

  attr_reader :position

  attr_reader :geological_index

  attr_reader :erosion_level

  def initialize(pos, geo_index, depth, is_origin: false, is_target: false)
    @position = pos
    @geological_index = geo_index
    @erosion_level = (@geological_index + depth) % EROSION_MOD
    @type = TYPE_MAP[@erosion_level % 3]
    @is_origin = is_origin
    @is_target = is_target
  end

  def risk_level
    RISK_LEVELS[@type]
  end

  def to_s
    return 'M' if @is_origin
    return 'T' if @is_target
    DISPLAY_MAP[@type]
  end
end

class Cave
  X_INDEX_MOD = 16807

  Y_INDEX_MOD = 48271

  attr_reader :depth

  def initialize(depth, origin, target)
    @depth = depth

    @origin_position = origin
    @target_position = target

    @regions = Hash.new { |xh, x| xh[x] = Hash.new { |yh, y| yh[y] = build_region Vector[x, y] } }
  end

  # Default value on y allows [] to be called with just a Vector
  def [](x, y = nil)
    return self[x.x, x.y] if x.is_a?(Vector)
    @regions[x][y]
  end

  def display(start, stop)
    (start.y..stop.y).each do |y|
      (start.x..stop.x).each do |x|
        print self[x, y].to_s
      end
      puts
    end
  end

  private

  def build_region(position)
    return Region.new position, 0, @depth, is_origin: true if position == @origin_position
    return Region.new position, 0, @depth, is_target: true if position == @target_position
    return Region.new position, position.x * X_INDEX_MOD, @depth if position.y == 0
    return Region.new position, position.y * Y_INDEX_MOD, @depth if position.x == 0
    previous_x_region = @regions[position.x - 1][position.y]
    previous_y_region = @regions[position.x][position.y - 1]
    Region.new position, previous_x_region.erosion_level * previous_y_region.erosion_level, @depth
  end
end

origin = Vector[0, 0]

lines = File.readlines('input.txt')

depth = lines.first.split(':').last.to_i
target = Vector.elements lines.last.split(':').last.split(',').map(&:to_i)

cave = Cave.new depth, origin, target

risk_level = (origin.x..target.x).to_a.product((origin.y..target.y).to_a).sum { |(x, y)| cave[x, y].risk_level }

puts "Part 1: #{risk_level}"
