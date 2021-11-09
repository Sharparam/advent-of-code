#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Particle
  attr_reader :position

  def initialize(pos, vel, acc)
    @position = pos
    @velocity = vel
    @acceleration = acc
    @orig_pos = @position
    @orig_vel = @velocity
    @orig_acc = @acceleration
  end

  def tick!
    @velocity += @acceleration
    @position += @velocity
  end

  def reset!
    @position = @orig_pos
    @velocity = @orig_vel
    @acceleration = @orig_acc
  end

  def distance
    @position.sum(&:abs)
  end
end

PARTICLES = ARGF.readlines.map { |l| Particle.new(*l.scan(/-?\d+/).map(&:to_i).each_slice(3).map { |s| Vector[*s] }) }

def tick!
  PARTICLES.each(&:tick!)
end

def min_index
  PARTICLES.each_with_index.min_by { |p, _| p.distance }[1]
end

# 1000 iterations seem to be enough
# TODO: Find a proper solution
ITERATIONS = 1000

ITERATIONS.times { tick! }

puts min_index

PARTICLES.each(&:reset!)

def clean!
  counts = PARTICLES.map(&:position).tally
  PARTICLES.reject! { |p| counts[p.position] > 1 }
end

ITERATIONS.times do
  tick!
  clean!
end

puts PARTICLES.size
