#!/usr/bin/env ruby
# frozen_string_literal: true

class Cuboid
  attr_reader :left, :right, :bottom, :top, :front, :back

  def initialize(left, right, bottom, top, front, back)
    @left = left
    @right = right
    @bottom = bottom
    @top = top
    @front = front
    @back = back
    @removed = []
  end

  def width = (right - left + 1).abs
  def height = (top - bottom + 1).abs
  def depth = (back - front + 1).abs

  def volume
    width * depth * height - @removed.sum(&:volume)
  end

  def clamp(range)
    Cuboid.new left.clamp(range), right.clamp(range), bottom.clamp(range), top.clamp(range), front.clamp(range), back.clamp(range)
  end

  def clamp!(range)
    @left = left.clamp range
    @right = right.clamp range
    @bottom = bottom.clamp range
    @top = top.clamp range
    @front = front.clamp range
    @back = back.clamp range
    self
  end

  def intersects?(other)
    top >= other.bottom && bottom <= other.top &&
      right >= other.left && left <= other.right &&
      back >= other.front && front <= other.back
  end

  def intersection(other)
    return nil unless intersects? other
    bottom = [@bottom, other.bottom].max
    top = [@top, other.top].min
    left = [@left, other.left].max
    right = [@right, other.right].min
    front = [@front, other.front].max
    back = [@back, other.back].min
    Cuboid.new(left, right, bottom, top, front, back)
  end

  def remove!(cuboid)
    @removed.each { |r| r.remove!(cuboid.intersection(r)) if r.intersects? cuboid }
    @removed << cuboid
  end

  def to_s
    "(X=#{left}..#{right},Y=#{bottom}..#{top},Z=#{front}..#{back})"
  end
end

def format_number(n)
  n.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1 ').reverse
end

reactor = []

ARGF.each_line do |line|
  op, ranges = line.split.then { [_1.to_sym, _2] }
  left, right, bottom, top, front, back = ranges.scan(/-?\d+/).map(&:to_i)
  cuboid = Cuboid.new(left, right, bottom, top, front, back)
  intersecting = reactor.select { |c| cuboid.intersects? c }
  intersecting.each do |c|
    intersection = c.intersection cuboid
    c.remove! intersection
  end
  reactor << cuboid if op == :on
end

puts reactor.sum(&:volume)
