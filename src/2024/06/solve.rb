#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

TYPES = {
  ?. => :empty,
  ?# => :wall,
  ?^ => :guard
}.freeze

MAP = ARGF.map.with_index { |line, y|
  line.chomp.chars.map.with_index { |tile, x|
    type = TYPES[tile]
    case type
    when :guard
      START = Vector[y, x].freeze
      :empty
    else
      type
    end
  }
}

HEIGHT = MAP.size
WIDTH = MAP[0].size

TURNS = {
  Vector[-1, 0] => Vector[0, 1],
  Vector[0, 1] => Vector[1, 0],
  Vector[1, 0] => Vector[0, -1],
  Vector[0, -1] => Vector[-1, 0]
}.freeze

def display(map, visited)
  p visited
  puts "=" * 40
  HEIGHT.times do |y|
    WIDTH.times do |x|
      if visited.include?(Vector[y, x])
        next print "X"
      end
      tile = map[y][x]
      case tile
      when :wall
        print ?#
      when :empty
        print ?.
      else
        print tile.to_s
      end
    end
    puts
  end
  puts "=" * 40
end

def travel(map)
  pos = START
  dir = Vector[-1, 0]
  visited = Set.new
  visited_2 = Set.new
  visited_2.add [START, Vector[-1, 0]]
  while pos[0].between?(0, HEIGHT - 1) && pos[1].between?(0, WIDTH - 1)
    visited.add pos
    new_pos = pos + dir
    break unless new_pos[0].between?(0, HEIGHT - 1) && new_pos[1].between?(0, WIDTH - 1)
    tile = map[new_pos[0]]&.[](new_pos[1])
    if tile == :wall
      visited_2.add [new_pos, dir]
      dir = TURNS[dir]
    else
      pos = new_pos
      return nil unless visited_2.add? [new_pos, dir]
    end
  end

  visited
end

visited = travel MAP

puts visited.size

loop_count = 0

visited.each_with_index do |v_pos, i|
  # puts "#{i + 1} / #{visited.size}" if (i + 1) % 100 == 0 || i + 1 == visited.size
  next if v_pos == START
  next if MAP[v_pos[0]][v_pos[1]] == :wall
  map = MAP.map(&:dup)
  map[v_pos[0]][v_pos[1]] = :wall
  loop_count += 1 if travel(map).nil?
end

puts loop_count
