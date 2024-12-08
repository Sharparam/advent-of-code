#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'
require 'pry'

DEBUG = ENV['DEBUG']

def lcm(a, b, c); a.lcm(b).lcm(c); end

class Vector
  def x; self[0]; end
  def y; self[1]; end
  def z; self[2]; end
  def abs_sum; sum(&:abs); end
end

class Moon
  attr_reader :position
  attr_reader :velocity

  def initialize(position)
    @position = position
    @velocity = Vector[0, 0, 0]
  end

  def self.parse(line)
    Moon.new Vector[*line.scan(/\-?\d+/).map(&:to_i)]
  end

  def potential_energy
    @position.abs_sum
  end

  def kinetic_energy
    @velocity.abs_sum
  end

  def total_energy
    potential_energy * kinetic_energy
  end

  def x_state
    [@position.x, @velocity.x]
  end

  def y_state
    [@position.y, @velocity.y]
  end

  def z_state
    [@position.z, @velocity.z]
  end

  def apply_gravity!(moon)
    change = Vector[
      moon.position.x <=> @position.x,
      moon.position.y <=> @position.y,
      moon.position.z <=> @position.z
    ]

    @velocity += change
  end

  def move!
    @position += @velocity
  end

  def eql?(other)
    @position == other.position && @velocity == other.velocity
  end

  def hash
    [@position, @velocity].hash
  end

  def to_s
    pos = @position
    vel = @velocity
    pos_s = 'pos=<x=%4d, y=%4d, z=%4d>' % [pos.x, pos.y, pos.z]
    vel_s = 'vel=<x=%4d, y=%4d, z=%4d>' % [vel.x, vel.y, vel.z]
    "#{pos_s}, #{vel_s}"
  end
end

class Simulation
  attr_reader :step
  attr_reader :moons

  def initialize(moons, debug = false)
    @step = 0
    @moons = moons
    @debug = debug
    @duped_x = false
    @duped_y = false
    @duped_z = false
    @x_states = Set.new
    @y_states = Set.new
    @z_states = Set.new
    save_states!
  end

  def step!
    @step += 1

    @moons.permutation(2) do |(a, b)|
      a.apply_gravity! b
    end

    @moons.each(&:move!)

    save_states!
  end

  def total_energy
    @moons.sum(&:total_energy)
  end

  def duped_x_found?; @duped_x; end
  def duped_y_found?; @duped_y; end
  def duped_z_found?; @duped_z; end

  def dupe_found?
    @duped_x && @duped_y && @duped_z
  end

  def dupe_at
    return nil unless dupe_found?

    lcm(@x_dupe_step, @y_dupe_step, @z_dupe_step)
  end

  def display
    @moons.each do |moon|
      puts moon
    end
  end

  private

  def save_states!
    xs = @moons.map(&:x_state)
    ys = @moons.map(&:y_state)
    zs = @moons.map(&:z_state)
    x_exists = @x_states.add?(xs.hash).nil?
    y_exists = @y_states.add?(ys.hash).nil?
    z_exists = @z_states.add?(zs.hash).nil?

    if x_exists && !@duped_x
      @duped_x = true
      @x_dupe_step = @step
      puts "Dupe in X found after #{@step} steps"
    end

    if y_exists && !@duped_y
      @duped_y = true
      @y_dupe_step = @step
      puts "Dupe in Y found after #{@step} steps"
    end

    if z_exists && !@duped_z
      @duped_z = true
      @z_dupe_step = @step
      puts "Dupe in Z found after #{@step} steps"
    end
  end
end

PATH = ARGV[0] || 'input'
STEPS = ARGV[1]&.to_i || 1000
moons = File.readlines(PATH).map { |l| Moon.parse l }
simulation = Simulation.new moons, DEBUG

simulation.display if DEBUG

loop do
  simulation.step!
  puts "\nAfter #{step} steps" if DEBUG
  simulation.display if DEBUG

  if simulation.step == STEPS
    puts "Part 1: #{simulation.total_energy}"
  end

  if simulation.dupe_found?
    puts "Part 2: #{simulation.dupe_at}"
  end

  break if simulation.step >= STEPS && simulation.dupe_found?
end
