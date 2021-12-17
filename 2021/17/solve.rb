#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Vector
  def x = self[0]
  def x=(v)
    self[0] = v
  end

  def y = self[1]
  def y=(v)
    self[1] = v
  end
end

X_RANGE, Y_RANGE = ARGF.read.scan(/-?\d+\.\.-?\d+/).map { eval _1 }

def test(x_range, y_range, velocity)
  position = Vector[0, 0]
  max_y = 0
  loop do
    position += velocity
    return false if position.y < y_range.min
    max_y = position.y if position.y > max_y
    velocity.x += velocity.x > 0 ? -1 : 1 if velocity.x != 0
    velocity.y -= 1
    return [true, max_y] if x_range.include?(position.x) && y_range.include?(position.y)
    return false if position.x < x_range.min && velocity.x <= 0
    return false if position.x > x_range.max && velocity.x >= 0
  end
end

successes = 0
max_y = 0

(1..X_RANGE.max).each do |x_vel|
  # magic max range found by experimentation
  (Y_RANGE.min..500).each do |y_vel|
    vel = Vector[x_vel, y_vel]
    success, max = test(X_RANGE, Y_RANGE, vel)
    next unless success
    successes += 1
    max_y = max if max > max_y
  end
end

puts max_y
puts successes
