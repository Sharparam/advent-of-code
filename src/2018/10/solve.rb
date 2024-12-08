#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Star
  attr_reader :pos

  def initialize(x, y, vx, vy)
    @pos = Vector[x, y]
    @vel = Vector[vx, vy]
  end

  def x; @pos[0]; end
  def y; @pos[1]; end
  def move!; @pos += @vel; end
  def rollback!; @pos -= @vel; end
end

STARS = File.readlines('input.txt').map { |l| l.scan /-?\d+/ }.map { |a| Star.new *a.map(&:to_i) }.freeze

def mm_x; STARS.map(&:x).minmax; end
def mm_y; STARS.map(&:y).minmax; end

def display
  (mm_y[0]..mm_y[1]).each do |y|
    puts (mm_x[0]..mm_x[1]).map { |x| STARS.any? { |s| s.pos == Vector[x, y] } ? '#' : '.' }.join
  end
end

(min_x, max_x) = mm_x
(min_y, max_y) = mm_y
grew = false
time = 0

until grew
  STARS.each(&:move!)
  (new_min_x, new_max_x) = mm_x
  (new_min_y, new_max_y) = mm_y
  grew = new_min_y < min_y || new_max_y > max_y || new_min_x < min_x || new_max_x > max_x
  min_x, max_x, min_y, max_y = new_min_x, new_max_x, new_min_y, new_max_y
  time += 1
end

STARS.each(&:rollback!)

puts 'Part 1:'
display

puts "Part 2: #{time - 1}"

# require 'pry'
# binding.pry
