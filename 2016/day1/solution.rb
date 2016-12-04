#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

input = STDIN.readline

moves = input.scan(/([RL])(\d+)/).map { |d, a| [d.downcase.to_sym, a.to_i] }

class Point
  MOVEMENT = {
    north: -> (steps) { [0, steps] },
    east: -> (steps) { [steps, 0] },
    south: -> (steps) { [0, -1 * steps] },
    west: -> (steps) { [-1 * steps, 0] }
  }.freeze

  attr_reader :x, :y

  attr_reader :twice

  def initialize
    @x = 0
    @y = 0
    @orientation = 0
    @visited = []
  end

  def orientation
    MOVEMENT.keys[@orientation]
  end

  def turn(direction)
    @orientation += direction == :r ? 1 : -1
    @orientation = 0 if @orientation >= MOVEMENT.keys.size
    @orientation = MOVEMENT.keys.size - 1 if @orientation < 0
  end

  def move(steps)
    dx, dy = MOVEMENT[orientation].call(steps)
    #puts "#{dx}, #{dy}"
    current = [@x, @y]
    target = [@x + dx, @y + dy]

    iterate_horizontal current[0], target[0] if current[1] == target[1]
    iterate_vertical current[1], target[1] if current[0] == target[0]

    @x, @y = target
  end

  def iterate_horizontal(current, target)
    # Exclude our current position from checks
    current = current + (current < target ? 1 : -1)
    # Swap values to make range work if we're walking to the left
    current, target = target, current if current > target
    (current..target).each do |x|
      if @visited.include? [x, @y]
        @twice = [x, @y] unless @twice
      else
        @visited << [x, @y]
      end
    end
  end

  def iterate_vertical(current, target)
    # Exclude our current position from checks
    current = current + (current < target ? 1 : -1)
    # Swap values to make range work if we're walking down
    current, target = target, current if current > target
    (current..target).each do |y|
      if @visited.include? [@x, y]
        @twice = [@x, y] unless @twice
      else
        @visited << [@x, y]
      end
    end
  end

  def shortest_path
    @x.abs + @y.abs
  end

  def real_shortest
    @twice.map(&:abs).inject(&:+)
  end
end

destination = Point.new

moves.each do |move|
  #puts "Move: #{move[0]} then #{move[1]} steps"
  destination.turn move[0]
  destination.move move[1]
end

puts "Target position: (#{destination.x}, #{destination.y})"

puts "(1) Shortest path is #{destination.shortest_path} steps long"

puts "(2) The REAL shortest path is #{destination.real_shortest} steps long"
