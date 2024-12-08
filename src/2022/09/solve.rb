#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

DELTAS = {
  U: Vector[0, 1],
  D: Vector[0, -1],
  L: Vector[-1, 0],
  R: Vector[1, 0]
}

MOVES = ARGF.readlines.map(&:split).map { |d, n| [d.to_sym, n.to_i] }

head = Vector[0, 0]
tails = 9.times.map { Vector[0, 0] }
visits = 9.times.map { Set[Vector[0, 0]]}

def cursed(h, t)
  hx, hy = h[0], h[1]
  tx, ty = t[0], t[1]
  dx, dy = hx - tx, hy - ty
  mx, my = 0, 0

  if dx.abs >= 2 && dy == 0
    mx = dx
    mx -= 1 if dx > 0
    mx += 1 if dx < 0
  elsif dy.abs >= 2 && dx == 0
    my = dy
    my -= 1 if dy > 0
    my += 1 if dy < 0
  elsif dx.abs >= 2 || dy.abs >= 2
    if dx.abs >= 2
      mx = dx
      mx -= 1 if dx > 0
      mx += 1 if dx < 0
    elsif dx.abs == 1
      mx = dx
    end

    if dy.abs >= 2
      my = dy
      my -= 1 if dy > 0
      my += 1 if dy < 0
    elsif dy.abs == 1
      my = dy
    end
  end

  Vector[mx, my]
end

MOVES.each do |dir, n|
  delta = DELTAS[dir]
  n.times do
    head += delta

    tails.each_with_index do |tail, i|
      parent = i == 0 ? head : tails[i - 1]
      move = cursed parent, tail
      tails[i] += move
      visits[i].add tails[i]
    end
  end
end

puts visits[0].size
puts visits[8].size
