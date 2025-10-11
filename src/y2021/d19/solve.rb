#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'pry'

DEBUG = false

def debug(msg = nil, &block)
  return unless DEBUG
  warn msg if msg
  block.call if block_given?
end

class Vector
  def x = self[0]
  def y = self[1]
  def z = self[2]

  def x=(v) self[0] = v end
  def y=(v) self[1] = v end
  def z=(v) self[2] = v end

  def to_s = "(#{x}, #{y}, #{z})"
  def inspect = to_s
end

V = Vector

TRANSFORMS = [
  ->(p) { V[p.z, p.y, -p.x] },
  ->(p) { V[-p.y,  p.z, -p.x] },
  ->(p) { V[-p.z, -p.y, -p.x] },
  ->(p) { V[p.y, -p.z, -p.x] },
  ->(p) { V[p.z,  p.x,  p.y] },
  ->(p) { V[-p.x,  p.z,  p.y] },
  ->(p) { V[-p.z, -p.x,  p.y] },
  ->(p) { V[p.x, -p.z,  p.y] },
  ->(p) { V[p.y,  p.x, -p.z] },
  ->(p) { V[-p.x,  p.y, -p.z] },
  ->(p) { V[-p.y, -p.x, -p.z] },
  ->(p) { V[p.x, -p.y, -p.z] },
  ->(p) { V[p.y,  p.z,  p.x] },
  ->(p) { V[-p.z,  p.y,  p.x] },
  ->(p) { V[-p.y, -p.z,  p.x] },
  ->(p) { V[p.z, -p.y,  p.x] },
  ->(p) { V[p.x,  p.z, -p.y] },
  ->(p) { V[-p.z,  p.x, -p.y] },
  ->(p) { V[-p.x, -p.z, -p.y] },
  ->(p) { V[p.z, -p.x, -p.y] },
  ->(p) { V[p.x,  p.y,  p.z] },
  ->(p) { V[-p.y,  p.x,  p.z] },
  ->(p) { V[-p.x, -p.y,  p.z] },
  ->(p) { V[p.y, -p.x, p.z] }
].freeze

def rotate(map)
  TRANSFORMS.map { |t| map.map { |p| t[p] } }
end

def manhattan(a, b)
  (a.x - b.x).abs + (a.y - b.y).abs + (a.z - b.z).abs
end

maps = ARGF.read.strip.split("\n\n").map { |s| s.lines[1..].map { Vector[*_1.split(',').map(&:to_i)] } }
maps_dict = maps.each_with_index.to_a.to_h(&:reverse)

current = maps_dict[0]
current_i = 0
solved = { 0 => current }
scanner_positions = [Vector[0, 0, 0]]

loop do
  unsolved_is = maps_dict.keys - solved.keys
  debug "Solved indices: #{solved.keys}"
  debug "Unsolved indices: #{unsolved_is}"
  debug "Trying to find a match for #{current_i}"
  break if solved.size == maps_dict.size
  solution = nil
  solution_i = nil
  solution_score = 0
  unsolved_is.each do |i|
    candidate = maps_dict[i]
    rotations = rotate candidate
    rotations.each do |rotation|
      diffs = current.product(rotation).map { _1 - _2 }
      diffs.each do |diff|
        translation = rotation.map { _1 + diff }
        common_count = (current & translation).size
        if common_count >= 12 && common_count > solution_score
          debug "Scanner #{i} matches with score #{common_count}"
          solution = translation
          solution_i = i
          solution_score = common_count
          scanner_positions << diff
          break
        end
        break if solution
      end
      break if solution
    end
    break if solution
  end
  if solution
    debug "Best match for #{current_i} is #{solution_i} (score: #{solution_score})"
    solution = solution.union current
    solved[solution_i] = solution
    current = solution
    current_i = solution_i
  else
    abort 'Failed to find a match'
  end
  debug ''
end

puts solved.values.flatten.uniq.size
puts scanner_positions.combination(2).map { manhattan(_1, _2) }.max

# binding.pry
