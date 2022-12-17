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

2022.times do |shape_index|
  shape = SHAPES[shape_index % SHAPES.size]
  shape_height = shape.map { _1[1] }.max + 1
  shape_width = shape.map { _1[0] }.max + 1
  highest_y = grid.map { _1[1] }.max # || 0

  shape_start = V[LEFT_START, highest_y + 4]

  shape = shape.map { _1 + shape_start }

  loop do
    movement = MOVEMENTS[movement_index % MOVEMENTS.size]
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

  puts grid.map { _1[1] }.max if shape_index == 2021
end
