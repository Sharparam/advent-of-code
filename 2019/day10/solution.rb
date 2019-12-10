#!/usr/bin/env ruby

require 'set'
require 'matrix'

DEBUG = ENV['DEBUG']
FLOAT_THRESHOLD = 10**(-5)

class Vector
  def x
    self[0]
  end

  def y
    self[1]
  end
end

def dist(a, b)
  Math.sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2)
end

def on_line?(a, b, point)
  xs = [a.x, b.x]
  ys = [a.y, b.y]
  top = ys.min
  bot = ys.max
  left = xs.min
  right = xs.max

  # if a.x == b.x
  #   return point.y >= top && point.y <= bot
  # end

  # if a.y == b.y
  #   return point.x >= left && point.x <= right
  # end

  dxc = point.x - a.x
  dyc = point.y - a.y
  dx1 = b.x - a.x
  dy1 = b.y - a.y
  cross = dxc * dy1 - dyc * dx1

  return false unless cross == 0

  if dx1.abs >= dy1.abs
    return dx1 > 0 ? a.x <= point.x && point.x <= b.x : b.x <= point.x && point.x <= a.x
  end

  return dy1 > 0 ? a.y <= point.y && point.y <= b.y : b.y <= point.y && point.y <= a.y
end

data = File.readlines(ARGV.first || 'input.txt')

points = Set.new

data.each_with_index do |line, line_index|
  line.chars.each_with_index do |char, char_index|
    points << Vector[char_index, line_index] if char == '#'
  end
end

stats = {}

points.each do |point|
  puts "Testing #{point}"
  stats[point] = 0
  targets = points.dup
  targets.delete point
  targets.each do |target|
    print "#{point} --> #{target}? " if DEBUG
    potentials = targets.dup
    potentials.delete target
    if DEBUG && false
      blocking = potentials.select { |p| on_line? point, target, p }
      puts "BLOCKING: "
      p blocking
      blocked = blocking.any?
    else
      blocked = potentials.any? { |p| on_line? point, target, p }
    end
    puts blocked ? "BLOCKED" : "OK" if DEBUG
    stats[point] += 1 unless blocked
  end
end

best = stats.max_by { |(k, v)| v }
best_point = best.first
best_visible = best.last
puts "Best point is #{best_point} which can see #{best_visible} asteroids"
puts "Part 1: #{stats.values.max}"

if DEBUG
  require 'pry'
  binding.pry
end
