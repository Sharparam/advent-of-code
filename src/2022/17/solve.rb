#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'

V = Vector

WIDTH = 7
MIN_X = 0
MAX_X = WIDTH - 1
LEFT_START = 2

PUSH_DOWN = V[0, -1]
MOVEMENTS = ARGF.read.strip.chars.map { V[-1 * (61 - _1.ord), 0] }

SHAPES = [
  # ####
  [V[0, 0], V[1, 0], V[2, 0], V[3, 0]],

  # .#.
  # ###
  # .#.
  [
    V[1, 2],
    V[0, 1], V[1, 1], V[2, 1],
    V[1, 0]
  ],

  # ..#
  # ..#
  # ###
  [
    V[2, 2],
    V[2, 1],
    V[0, 0], V[1, 0], V[2, 0]
  ],

  # #
  # #
  # #
  # #
  [
    V[0, 3],
    V[0, 2],
    V[0, 1],
    V[0, 0]
  ],

  # ##
  # ##
  [
    V[0, 1], V[1, 1],
    V[0, 0], V[1, 0]
  ]
]

grid = (0..MAX_X).map { V[_1, 0] }.to_set
movement_index = 0

checks = {}

ROUNDS = 1_000_000_000_000

i = 0

part2_diff = 0
found_cycle = false

while i < ROUNDS
  s_i = i % SHAPES.size
  shape = SHAPES[s_i]
  shape_height = shape.map { _1[1] }.max + 1
  shape_width = shape.map { _1[0] }.max + 1
  highest_y = grid.map { _1[1] }.max # || 0

  shape_start = V[LEFT_START, highest_y + 4]

  shape = shape.map { _1 + shape_start }

  loop do
    m_i = movement_index % MOVEMENTS.size
    movement = MOVEMENTS[m_i]
    movement_index += 1
    new_shape = shape.map { _1 + movement }
    unless new_shape.any? { grid.include?(_1) || _1[0] < 0 || _1[0] > MAX_X }
      shape = new_shape
    end

    new_shape = shape.map { _1 + PUSH_DOWN }

    break if new_shape.any? { grid.include?(_1) }

    shape = new_shape
  end

  shape.each { grid.add _1 }

  new_highest_y = grid.map { _1[1] }.max

  # Part 1
  puts new_highest_y if i == 2021

  if i > 2021 && !found_cycle
    y = new_highest_y
    top = (0..MAX_X).map { |x| grid.include?(V[x, y]) ? '#' : '.' }
    hash = [s_i, movement_index % MOVEMENTS.size, *top].hash

    if checks.key?(hash)
      found_cycle = true
      data = checks[hash]
      previous_height = data[:height]
      previous_i = data[:i]
      cycle_size = i - previous_i
      height_diff = y - previous_height

      STDERR.puts '=== CYCLE DETECTED ==='
      STDERR.puts "Current i: #{i}; Previous i: #{previous_i}; DIFF: #{cycle_size}"
      STDERR.puts "Current y: #{y}; Previous y: #{previous_height}; DIFF: #{height_diff}"

      remaining_i = ROUNDS - i
      remaining_cycles = remaining_i / cycle_size

      STDERR.puts "Remaining rocks: #{remaining_i}; Remaining cycles: #{remaining_cycles}"

      add_i = cycle_size * remaining_cycles
      add_height = remaining_cycles * height_diff
      i += add_i
      part2_diff = add_height

      STDERR.puts "New i is #{i}"
    else
      checks[hash] = { height: y, i: i }
    end
  end

  i += 1
end

max_y = grid.map { _1[1] }.max

# Part 2
puts max_y + part2_diff
