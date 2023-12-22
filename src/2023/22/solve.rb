#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'

class Range
  def intersects?(other)
    (self.max >= other.min && self.max <= other.max) || (self.min >= other.min && self.min <= other.max)
  end
end

def make_range(a, b)
  min, max = [a, b].minmax
  (min..max)
end

class Point
  include Comparable
  attr_reader :x, :y, :z

  def initialize(x, y, z)
    @x, @y, @z = x, y, z
    @hash = [@x, @y, @z].hash
  end

  def self.[](x, y, z)
    Point.new x, y, z
  end

  def <=>(other)
    return z <=> other.z unless z == other.z
    return x <=> other.x unless x == other.x
    return y <=> other.y unless y == other.y
    0
  end

  def eql?(other) = self == other
  def hash = @hash

  def dup = Point[@x, @y, @z]
  def clone = dup

  def to_s = "(#{@x}, #{@y}, #{@z})"
  def inspect = to_s
  def to_v = Vector[@x, @y, @z]
end

class Brick
  attr_reader :start, :stop
  attr_reader :xrange, :yrange, :zrange

  def initialize(start, stop)
    @start, @stop = start, stop
    raise "start x > stop x" if start.x > stop.x
    raise "start y > stop y" if start.y > stop.y
    raise "start y > stop y" if start.y > stop.y
    @xrange = (@start.x .. @stop.x) # make_range @start.x, @stop.x
    @yrange = (@start.y .. @stop.y) # make_range @start.y, @stop.y
    @zrange = (@start.z .. @stop.z) # make_range @start.z, @stop.z
    @hash = [start, stop].hash
  end

  def ==(other) = @start == other.start && @stop == other.stop
  def eql?(other) = self == other
  def hash = @hash

  def include?(point)
    @xrange.include?(point.x) && @yrange.include?(point.y) && @zrange.include?(point.z)
  end

  def dup = Brick.new @start.dup, @stop.dup
  def clone = dup

  def to_s = "#{start} ~ #{stop}"
  def inspect = to_s
end

class Grid
  attr_reader :bricks

  def initialize(bricks = [])
    @bricks = bricks
    @hash = @bricks.hash
  end

  def push(brick)
    @bricks.push brick
  end

  def <<(brick)
    push brick
  end

  def concat(bricks)
    @bricks.concat bricks
  end

  def dup = Grid.new @bricks.map(&:dup)
  def clone = dup

  def step
    # puts "stepping"
    z_max = @bricks.map { |b| b.zrange.max }.max

    return [self.dup, false] if z_max < 2

    new_grid = Grid.new
    moved = false

    (1..z_max).each do |z|
      z_bricks = @bricks.select { |b| b.zrange.min == z }
      if z == 1
        new_grid.concat z_bricks.map(&:dup)
        next
      end
      below_bricks = @bricks.select { |b| b.zrange.max == z - 1 }
      # xranges, yranges = below_bricks.map { |b| [b.xrange, b.yrange] }.transpose
      xs = below_bricks.flat_map { |b| b.xrange.to_a }.uniq
      ys = below_bricks.flat_map { |b| b.yrange.to_a }.uniq
      xys = xs.product(ys).to_set
      # puts "at Z = #{z}, supporting coords: #{xys}"
      # puts "#{bricks.size} bricks to process"
      z_bricks.each do |brick|
        bxs = brick.xrange.to_a
        bys = brick.yrange.to_a
        bxys = bxs.product(bys)
        supported = bxys.any? { xys.include? _1 }
        if supported
          new_grid.push brick.dup
        else
          new_brick = Brick.new(Point[brick.start.x, brick.start.y, brick.start.z - 1], Point[brick.stop.x, brick.stop.y, brick.stop.z - 1])
          # puts "  #{brick} is moving to #{new_brick}"
          new_grid.push new_brick
          moved = true
        end
      end
    end

    [new_grid, moved]
  end

  def is_settled?
    z_max = @bricks.map { |b| b.zrange.max }.max

    return true if z_max < 2

    settled = true

    (1..z_max).each do |z|
      z_bricks = @bricks.select { |b| b.zrange.min == z }
      if z == 1
        next
      end
      below_bricks = @bricks.select { |b| b.zrange.max == z - 1 }
      xs = below_bricks.flat_map { |b| b.xrange.to_a }.uniq
      ys = below_bricks.flat_map { |b| b.yrange.to_a }.uniq
      xys = xs.product(ys).to_set
      z_bricks.each do |brick|
        bxs = brick.xrange.to_a
        bys = brick.yrange.to_a
        bxys = bxs.product(bys)
        supported = bxys.any? { xys.include? _1 }
        if supported
          next
        else
          settled = false
        end
      end
    end

    settled
  end

  def settle
    new_grid, moved = step
    while moved
      # puts "continuing"
      new_grid, moved = new_grid.step
    end

    new_grid
  end

  def display
    x_min = @bricks.map { |b| b.xrange.min }.min
    x_max = @bricks.map { |b| b.xrange.max }.max
    y_min = @bricks.map { |b| b.yrange.min }.min
    y_max = @bricks.map { |b| b.yrange.max }.max
    z_min = 0
    z_max = @bricks.map { |b| b.zrange.max }.max
    x_width = x_max - x_min + 1
    y_width = y_max - y_min + 1
    x_floor = "-" * x_width
    y_floor = "-" * y_width

    puts " x#{' ' * (x_width - 2)}   y#{' ' * (y_width - 2)}"
    x_width.times { |i| print i }
    print "  "
    y_width.times { |i| print i }
    puts
    z_max.downto(0).each do |z|
      if z == 0
        puts "#{x_floor}  #{y_floor}  0"
        next
      end

      x_width.times do |x|
        if @bricks.any? { |b| b.xrange.include?(x) && b.zrange.include?(z) }
          print '#'
        else
          print '.'
        end
      end

      print "  "

      y_width.times do |y|
        if @bricks.any? { |b| b.yrange.include?(y) && b.zrange.include?(z) }
          print '#'
        else
          print '.'
        end
      end

      puts "  #{z}"
    end
  end
end

grid = Grid.new ARGF.readlines(chomp: true).map {
  _1.split ?~
}.map { |first, second|
  starts = first.split(?,).map(&:to_i)
  stops = second.split(?,).map(&:to_i)
  startx, stopx = [starts[0], stops[0]].minmax
  starty, stopy = [starts[1], stops[1]].minmax
  startz, stopz = [starts[2], stops[2]].minmax
  start = Point[startx, starty, startz]
  stop = Point[stopx, stopy, stopz]
  Brick.new start, stop
}

settled = grid.settle

puts "settled"

settled.display

bricks = settled.bricks.map(&:dup)

puts "#{bricks.size} bricks to test"

n = 0
bricks.size.times do |i|
  # puts "testing index #{i}"
  new_bricks = bricks.dup
  new_bricks.delete_at i
  new_grid = Grid.new new_bricks
  settled = new_grid.is_settled?
  n += 1 if settled
end

puts n
