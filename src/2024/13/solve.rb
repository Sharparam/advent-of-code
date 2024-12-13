#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Vector
  def x = self[0]
  def y = self[1]
  def to_s = "(#{x}, #{y})"
end

COSTS = {
  A: 3,
  B: 1
}.freeze

A_COST = 3
B_COST = 1

machines = ARGF.read.scan(/\d+/).map(&:to_i).each_slice(6).map do |data|
  {
    A: Vector[data[0], data[1]],
    B: Vector[data[2], data[3]],
    GOAL: Vector[data[4], data[5]]
  }
end

def cost_d(machine, goal = nil)
  goal ||= machine[:GOAL]
  a = machine[:A]
  b = machine[:B]
  queue = [[Vector[0, 0], 0, 0, 0]]
  min_so_far = nil

  seen = Set.new

  until queue.empty?
    state = queue.pop
    next unless seen.add? state
    pos, a_count, b_count, cost = state
    next if a_count > 100 || b_count > 100
    next if pos.x > goal.x || pos.y > goal.y
    next if !min_so_far.nil? && cost >= min_so_far
    if pos == goal
      min_so_far = cost if min_so_far.nil? || cost < min_so_far
      next
    end
    queue.push [pos + a, a_count + 1, b_count, cost + A_COST]
    queue.push [pos + b, a_count, b_count + 1, cost + B_COST]
  end

  min_so_far
end

puts machines.map { cost_d _1 }.compact.sum

# The below would be a brute force part 2 and won't work
# PART2_DIFF = 10_000_000_000_000

# puts machines.map { cost_d _1, Vector[_1[:GOAL][0] + PART2_DIFF, _1[:GOAL][1] + PART2_DIFF] }
