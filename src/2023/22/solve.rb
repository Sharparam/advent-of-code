#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

def cantor(x, y)
  ((x + y) * (x + y + 1)) / 2 + y
end

def cantor_n(*v)
  v[1..].reduce(v[0]) { |a, e| cantor(a, e) }
end

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x, @y = x, y
  end

  def self.[](x, y) = Point.new x, y

  def ==(other) = @hash == other.hash
  def eql?(other) = self == other
  def dup = Point.new x, y
  def clone = dup
  def to_s = "(#{x}, #{y})"
  def inspect = to_s
end

class Rect
  attr_reader :start, :stop, :hash

  def initialize(start, stop)
    @start, @stop = start, stop
    @hash = cantor(start.hash, stop.hash)
  end

  def intersects?(other)
    return false if stop.x < other.start.x || start.x > other.stop.x || stop.y < other.start.y || start.y > other.stop.y
    true
  end
end

class Brick
  attr_reader :startx, :starty, :stopx, :stopy
  attr_accessor :startz, :stopz
  attr_reader :rect

  def initialize(startx, starty, startz, stopx, stopy, stopz)
    @startx, @starty, @startz, @stopx, @stopy, @stopz = startx, starty, startz, stopx, stopy, stopz
    @rect = Rect.new Point[@startx, @starty], Point[@stopx, @stopy]
  end

  def rests_on?(other, offset = 0)
    return false unless @startz - offset == other.stopz + 1
    return rect.intersects? other.rect
  end

  def dup = Brick.new @startx, @starty, @startz, @stopx, @stopy, @stopz
  def clone = dup

  def to_s = "(#{@startx}, #{@starty}, #{@startz}) ~ (#{@stopx}, #{@stopy}, #{@stopz})"
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

  def settle!
    sorted_bricks = @bricks.select { |b| b.startz > 1 }.sort_by { |b| b.startz }

    below = Hash.new { |h, k| h[k] = [] }

    @bricks.select { |b| b.startz == 1 }.each { |b| below[b.stopz].push b }

    moved = 0

    sorted_bricks.each do |brick|
      next below[brick.stopz].push brick if below[brick.startz - 1].any? { |b| brick.rests_on? b }
      moved += 1
      reduction = 1
      reduction += 1 while brick.startz - reduction > 1 && !below[brick.startz - 1 - reduction].any? { |b| brick.rests_on?(b, reduction) }
      brick.startz -= reduction
      brick.stopz -= reduction
      below[brick.stopz].push brick
    end

    moved
  end

  def display
    x_min = @bricks.map { |b| b.startx }.min
    x_max = @bricks.map { |b| b.stopx }.max
    y_min = @bricks.map { |b| b.starty }.min
    y_max = @bricks.map { |b| b.stopy }.max
    z_min = 0
    z_max = @bricks.map { |b| b.stopz }.max
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
        if @bricks.any? { |b| (b.startx .. b.stopx).include?(x) && (b.startz .. b.stopz).include?(z) }
          print '#'
        else
          print '.'
        end
      end

      print "  "

      y_width.times do |y|
        if @bricks.any? { |b| (b.starty .. b.stopy).include?(y) && (b.startz .. b.stopz).include?(z) }
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
  Brick.new startx, starty, startz, stopx, stopy, stopz
}

grid.settle!

n = 0
total = 0
grid.bricks.size.times do |i|
  new_grid = grid.dup
  new_grid.bricks.delete_at i
  moved = new_grid.settle!
  n += 1 if moved == 0
  total += moved
end

puts n
puts total
