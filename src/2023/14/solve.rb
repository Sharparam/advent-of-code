#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

$grid = Hash[ARGF.readlines(chomp: true).flat_map.with_index { |line, y|
  line.chars.map.with_index { |t, x| [Vector[x, y], t] }
}]

WIDTH = $grid.keys.map { _1[0] }.max + 1
HEIGHT = $grid.keys.map { _1[1] }.max + 1

XS = (0...WIDTH).to_a
YS = (0...HEIGHT).to_a

DIRECTIONS = {
  N: Vector[0, -1],
  W: Vector[-1, 0],
  S: Vector[0, 1],
  E: Vector[1, 0]
}.freeze

POSES = {
  N: YS.flat_map { |y| XS.map { |x| Vector[x, y] } },
  S: YS.reverse.flat_map { |y| XS.map { |x| Vector[x, y] } },
  E: YS.flat_map { |y| XS.reverse.map { |x| Vector[x, y] } }
}.freeze

POSES[:W] = POSES[:N]

STOPS = {
  N: ->(v) { v[1] == 0 },
  W: ->(v) { v[0] == 0 },
  S: ->(v) { v[1] == HEIGHT - 1 },
  E: ->(v) { v[0] == WIDTH - 1 }
}.freeze

def display
  puts '=' * WIDTH
  (0...HEIGHT).each do |y|
    (0...WIDTH).each do |x|
      print $grid[Vector[x, y]]
    end
    puts
  end
  puts '=' * WIDTH
end

def load
  $grid.sum { |k, v| v == ?O ? HEIGHT - k[1] : 0 }
end

$first = true
def tilt(dir)
  order = POSES[dir]
  delta = DIRECTIONS[dir]
  stop = STOPS[dir]
  order.each do |pos|
    next unless $grid[pos] == ?O
    until stop.(pos)
      new = pos + delta
      break if $grid[new] == ?O || $grid[new] == ?#
      $grid[new] = ?O
      $grid[pos] = ?.
      pos = new
    end
  end
  return unless $first
  $first = false
  puts load
end

def cycle
  %i[N W S E].each { tilt(_1) }
end

def id
  $grid.select { _2 == ?O }.map(&:first).map { _1[0] + WIDTH * _1[1] }
end

states = { id => { load: load, index: 0 } }

(1..).each do |i|
  cycle
  l = load
  i_id = id
  if !states.key? i_id
    states[i_id] = { load: l, index: i }
  else
    old = states[i_id]
    start_index = old[:index]
    loads = Hash[states.map { |_k, v| [v[:index], v[:load]] }]
    cycle_size = i - start_index
    cycle_steps = 1_000_000_000 - start_index
    cycle_index = cycle_steps % cycle_size
    puts loads[start_index + cycle_index]
    break
  end
end
