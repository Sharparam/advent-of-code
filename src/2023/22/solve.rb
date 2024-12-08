#!/usr/bin/env ruby
# frozen_string_literal: true

class Rect
  attr_reader :startx, :starty, :stopx, :stopy

  def initialize(startx, starty, stopx, stopy)
    @startx, @starty, @stopx, @stopy = startx, starty, stopx, stopy
  end

  def intersects?(other)
    return false if stopx < other.startx || startx > other.stopx || stopy < other.starty || starty > other.stopy
    true
  end
end

class Brick
  attr_reader :startx, :starty, :stopx, :stopy, :rect
  attr_accessor :startz, :stopz

  def initialize(startx, starty, startz, stopx, stopy, stopz)
    @startx, @starty, @startz, @stopx, @stopy, @stopz = startx, starty, startz, stopx, stopy, stopz
    @rect = Rect.new @startx, @starty, @stopx, @stopy
  end

  def dup = Brick.new @startx, @starty, @startz, @stopx, @stopy, @stopz
end

class Grid
  attr_reader :bricks

  def initialize(bricks = [])
    @bricks = bricks
  end

  def dup = Grid.new @bricks.map(&:dup)

  def settle!
    sorted_bricks = @bricks.select { |b| b.startz > 1 }.sort_by(&:startz)

    rects = Hash.new { |h, k| h[k] = [] }
    @bricks.select { |b| b.startz == 1 }.each { |b| rects[b.stopz].push b.rect }
    moved = 0

    sorted_bricks.each do |brick|
      next rects[brick.stopz].push brick.rect if rects[brick.startz - 1].any? { |r| brick.rect.intersects? r }
      moved += 1
      reduction = 1
      reduction += 1 while brick.startz - reduction > 1 && rects[brick.startz - 1 - reduction].none? { |r| brick.rect.intersects? r }
      brick.startz -= reduction
      brick.stopz -= reduction
      rects[brick.stopz].push brick.rect
    end

    moved
  end
end

grid = Grid.new ARGF.readlines.map { Brick.new *_1.scan(/\d+/).map(&:to_i) }

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
