#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Nanobot
  include Comparable

  @@id = 0

  attr_reader :position

  attr_reader :range

  def initialize(x, y, z, range)
    @id = @@id += 1
    @position = Vector[x.to_i, y.to_i, z.to_i]
    @range = range.to_i
  end

  def x; position[0]; end
  def y; position[1]; end
  def z; position[2]; end

  def <=>(other)
    range <=> other.range
  end

  def distance_to(other)
    (position - (other.respond_to?(:position) ? other.position : other)).sum(&:abs)
  end

  def can_reach?(other)
    distance_to(other) <= range
  end

  def to_s
    "pos <=#{position[0]},#{position[1]},#{position[2]}>, r=#{range}"
  end
end

def count_in_range(bots, position)

end

bots = File.read('input.txt').scan(/(-?\d+).+?(-?\d+).+?(-?\d+).+?(\d+)/).map { |x, y, z, r| Nanobot.new x, y, z, r }

strongest = bots.max

in_range = bots.select { |b| strongest.can_reach? b }

puts "Part 1: #{in_range.size}"
