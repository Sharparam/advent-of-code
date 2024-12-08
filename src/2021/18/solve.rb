#!/usr/bin/env ruby
# frozen_string_literal: true

class Pair
  SIDE_INSPECT_S = { root: '', left: 'L', right: 'R' }.freeze

  attr_accessor :parent, :left, :right, :side

  def initialize(parent, left, right, side)
    @parent = parent
    @left = left
    @right = right
    @side = side
    if @left.is_a?(Pair)
      @left.parent = self
      @left.side = :left
    end
    if @right.is_a?(Pair)
      @right.parent = self
      @right.side = :right
    end
  end

  def self.from_array(array, parent = nil, side = :root)
    pair = Pair.new(parent, nil, nil, side)

    if array[0].is_a? Numeric
      pair.left = array[0]
    else
      pair.left = from_array(array[0], pair, :left)
    end

    if array[1].is_a? Numeric
      pair.right = array[1]
    else
      pair.right = from_array(array[1], pair, :right)
    end

    pair
  end

  def self.combine(left, right)
    Pair.new(nil, left, right, :root)
  end

  def left?
    @side == :left
  end

  def right?
    @side == :right
  end

  def root?
    @side == :root
  end

  def plain?
    left.is_a?(Numeric) && right.is_a?(Numeric)
  end

  def depth
    return 0 if parent.nil?
    1 + parent.depth
  end

  def magnitude
    left_mag = (left.is_a?(Pair) ? left.magnitude : left) * 3
    right_mag = (right.is_a?(Pair) ? right.magnitude : right) * 2
    left_mag + right_mag
  end

  def add_ancestor_left(value, came_from = nil, direction = :left)
    if came_from.nil?
      return if parent.nil?
      parent.add_ancestor_left(value, self, direction)
    elsif direction == :left
      if @left.is_a?(Numeric)
        @left += value
      elsif @left == came_from
        return if parent.nil?
        parent.add_ancestor_left(value, self, direction)
      else
        @left.add_ancestor_left(value, self, :right)
      end
    else
      if @right.is_a?(Numeric)
        @right += value
      else
        @right.add_ancestor_left(value, self, :right)
      end
    end
  end

  def add_ancestor_right(value, came_from = nil, direction = :right)
    if came_from.nil?
      return if parent.nil?
      parent.add_ancestor_right(value, self, direction)
    elsif direction == :right
      if @right.is_a?(Numeric)
        @right += value
      elsif @right == came_from
        return if parent.nil?
        parent.add_ancestor_right(value, self, direction)
      else
        @right.add_ancestor_right(value, self, :left)
      end
    else
      if @left.is_a?(Numeric)
        @left += value
      else
        @left.add_ancestor_right(value, self, :left)
      end
    end
  end

  def dup
    p_dup(nil)
  end
  def p_dup(dup_p = nil)
    Pair.new(dup_p, left.is_a?(Numeric) ? left : left.p_dup(self), right.is_a?(Numeric) ? right : right.p_dup(self), side)
  end

  def to_s
    "[#{left.to_s}, #{right.to_s}]"
  end

  def inspect
    "#{SIDE_INSPECT_S[side]}(#{left.inspect}, #{right.inspect})"
  end
end

def explode(pair)
  return false unless pair.is_a?(Pair)

  if pair.depth >= 4 && pair.plain?
    pair.add_ancestor_left pair.left
    pair.add_ancestor_right pair.right
    pair.parent.send("#{pair.side}=", 0)
    return true
  end

  return true if explode(pair.left)
  return true if explode(pair.right)

  false
end

def split(pair)
  return false unless pair.is_a?(Pair)

  if pair.left.is_a?(Numeric) && pair.left >= 10
    pair.left = Pair.new(pair, pair.left / 2, (pair.left / 2.0).ceil, :left)
    return true
  end

  return true if split(pair.left)

  if pair.right.is_a?(Numeric) && pair.right >= 10
    pair.right = Pair.new(pair, pair.right / 2, (pair.right / 2.0).ceil, :right)
    return true
  end

  return true if split(pair.right)

  false
end

def sum(a, b)
  result = Pair.combine a, b
  loop do
    exploded = explode result
    next if exploded
    splitted = split result
    break unless splitted
  end
  result
end

pairs = ARGF.readlines.map { Pair.from_array(eval(_1)) }
part2 = pairs.map(&:dup)

puts pairs.reduce { sum _1, _2 }.magnitude
puts part2.permutation(2).map { sum(_1.dup, _2.dup).magnitude }.max
