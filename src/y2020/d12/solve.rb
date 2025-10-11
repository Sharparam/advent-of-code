#!/usr/bin/env ruby
# frozen_string_literal: true

moves = ARGF.read.scan(/([A-Z])(\d+)/).map { [_1.to_sym, _2.to_i] }

pos = [0, 0]
facing = 90
MULS = { R: 1, L: -1, N: -1, S: 1, E: 1, W: -1 }.freeze
VECS = [[0, -1], [1, 0], [0, 1], [-1, 0]].freeze

move = ->(val) {
  dx, dy = VECS[facing / 90]
  pos[0] += dx * val
  pos[1] += dy * val
}

moves.each do |type, val|
  case type
  when :R, :L
    facing = (facing + (MULS[type] * val)) % 360
  when :F
    move[val]
  when :N, :S
    pos[1] += MULS[type] * val
  when :E, :W
    pos[0] += MULS[type] * val
  end
end

puts pos.sum(&:abs)

ship = [0, 0]
waypoint = [10, -1]

moves.each do |type, val|
  case type
  when :R, :L
    (val / 90).times do
      mul = MULS[type]
      waypoint[0], waypoint[1] = -1 * mul * waypoint[1], mul * waypoint[0]
    end
  when :F
    ship[0] += waypoint[0] * val
    ship[1] += waypoint[1] * val
  when :N, :S
    waypoint[1] += MULS[type] * val
  when :E, :W
    waypoint[0] += MULS[type] * val
  end
end

puts ship.sum(&:abs)
