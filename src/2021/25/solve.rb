#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

map = Hash[ARGF.readlines.map(&:chomp).flat_map.with_index do |line, y|
  line.chars.map.with_index do |cell, x|
    [Vector[x, y], cell]
  end
end]

WIDTH = map.keys.map { _1[0] }.max + 1
HEIGHT = map.keys.map { _1[1] }.max + 1

def wrapget(map, pos)
  return map[Vector[0, pos[1]]] if pos[0] >= WIDTH
  return map[Vector[WIDTH - 1, pos[1]]] if pos[0] < 0
  return map[Vector[pos[0], 0]] if pos[1] >= HEIGHT
  return map[Vector[pos[0], HEIGHT - 1]] if pos[1] < 0
  map[pos]
end

def wrapset(map, pos, val)
  if pos[0] >= WIDTH
    map[Vector[0, pos[1]]] = val
  elsif pos[0] < 0
    map[Vector[WIDTH - 1, pos[1]]] = val
  elsif pos[1] >= HEIGHT
    map[Vector[pos[0], 0]] = val
  elsif pos[1] < 0
    map[Vector[pos[0], HEIGHT - 1]] = val
  else
    map[pos] = val
  end
end

def step(map)
  moved = 0
  easts = map.select { _2 == '>' && wrapget(map, _1 + Vector[1, 0]) == '.' }
  easts.each do |pos, type|
    map[pos] = '.'
    wrapset(map, pos + Vector[1, 0], '>')
    moved += 1
  end
  souths = map.select { _2 == 'v' && wrapget(map, _1 + Vector[0, 1]) == '.' }
  souths.each do |pos, type|
    map[pos] = '.'
    wrapset(map, pos + Vector[0, 1], 'v')
    moved += 1
  end
  moved
end

steps = 1
steps += 1 while step(map) > 0

puts steps
