#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

MAP, PATH = ARGF.read.split("\n\n")

TILES = {
  ' ' => nil,
  '.' => :open,
  '#' => :wall
}

GRID = MAP.lines.map(&:chomp).flat_map.with_index do |line, y|
  line.chars.map.with_index { |c, x| [Vector[x, y], TILES[c]] }
end.to_h.compact.freeze

MOVES = PATH.scan(/\d+|R|L/).map { _1 == ?R ? :r : _1 == ?L ? :l : _1.to_i }.freeze

class Vector
  def x()
    self[0]
  end

  def x=(v)
    self[0] = v
  end

  def y()
    self[1]
  end

  def y=(v)
    self[1] = v
  end

  def r()
    Vector[-self.y, self.x]
  end

  def l()
    Vector[self.y, -self.x]
  end

  def to_s
    "(#{x}, #{y})"
  end
end

UP = Vector[0, -1]
RIGHT = Vector[1, 0]
DOWN = Vector[0, 1]
LEFT = Vector[-1, 0]
DIR_VALS = {
  RIGHT => 0,
  DOWN => 1,
  LEFT => 2,
  UP => 3
}.freeze

min_x = GRID.select { _2 == :open && _1[1] == 0 }.map { _1[0].x }.min
pos = Vector[min_x, 0]
direction = RIGHT

MOVES.each do |move|
  case move
  when :r
    direction = direction.r
  when :l
    direction = direction.l
  else
    move.times do
      next_pos = pos + direction

      if GRID[next_pos].nil?
        if direction.x > 0 # moving right
          next_x = GRID.keys.select { _1.y == pos.y }.map { _1.x }.min
          next_pos.x = next_x
        elsif direction.x < 0 # moving left
          next_x = GRID.keys.select { _1.y == pos.y }.map { _1.x }.max
          next_pos.x = next_x
        elsif direction.y > 0 # moving down
          next_y = GRID.keys.select { _1.x == pos.x }.map { _1.y }.min
          next_pos.y = next_y
        elsif direction.y < 0 # moving up
          next_y = GRID.keys.select { _1.x == pos.x }.map { _1.y }.max
          next_pos.y = next_y
        end
      end

      break if GRID[next_pos] == :wall

      pos = next_pos
    end
  end
end

puts (pos.y + 1) * 1000 + (pos.x + 1) * 4 + DIR_VALS[direction]

pos = Vector[min_x, 0]
direction = RIGHT

def resolve(pos, direction)
  next_pos = pos + direction
  next_direction = direction

  if GRID[next_pos].nil?
    x, y = next_pos.x, next_pos.y

    if direction == LEFT && x == 49 && y >= 0 && y <= 49
      # Going from 1 to 4
      x, y = 0, 149 - y
      next_direction = RIGHT
    elsif direction == UP && x >= 50 && x <= 99 && y == -1
      # Going from 1 to 6
      x, y = 0, x + 100
      next_direction = RIGHT
    elsif direction == UP && x >= 100 && x <= 149 && y == -1
      # Going from 2 to 6
      x, y = x - 100, 199
      next_direction = UP
    elsif direction == RIGHT && x == 150 && y >= 0 && y <= 49
      # Going from 2 to 5
      x, y = 99, 149 - y
      next_direction = LEFT
    elsif direction == DOWN && x >= 100 && x <= 149 && y == 50
      # Going from 2 to 3
      x, y = 99, x - 50
      next_direction = LEFT
    elsif direction == LEFT && x == 49 && y >= 50 && y <= 99
      # Going from 3 to 4
      x, y = y - 50, 100
      next_direction = DOWN
    elsif direction == RIGHT && x == 100 && y >= 50 && y <= 99
      # Going from 3 to 2
      x, y = 50 + y, 49
      next_direction = UP
    elsif direction == UP && x >= 0 && x <= 49 && y == 99
      # Going from 4 to 3
      x, y = 50, 50 + x
      next_direction = RIGHT
    elsif direction == LEFT && x == -1 && y >= 100 && y <= 149
      # Going from 4 to 1
      x, y = 50, 149 - y
      next_direction = RIGHT
    elsif direction == RIGHT && x == 100 && y >= 100 && y <= 149
      # Going from 5 to 2
      x, y = 149, 149 - y
      next_direction = LEFT
    elsif direction == DOWN && x >= 50 && x <= 99 && y == 150
      # Going from 5 to 6
      x, y = 49, x + 100
      next_direction = LEFT
    elsif direction == LEFT && x == -1 && y >= 150 && y <= 199
      # Going from 6 to 1
      x, y = y - 100, 0
      next_direction = DOWN
    elsif direction == DOWN && x >= 0 && x <= 49 && y == 200
      # Going from 6 to 2
      x, y = x + 100, 0
      next_direction = DOWN
    elsif direction == RIGHT && x == 50 && y >= 150 && y <= 199
      # Going from 6 to 5
      x, y = y - 100, 149
      next_direction = UP
    else
      puts "=== UNHANDLED WRAP ==="
      puts "At (#{pos.x}, #{pos.y}) going (#{direction.x}, #{direction.y})"
      abort
    end

    next_pos = Vector[x, y]
  end

  [next_pos, next_direction]
end

MOVES.each do |move|
  case move
  when :r
    direction = direction.r
  when :l
    direction = direction.l
  else
    move.times do
      next_pos, next_direction = resolve(pos, direction)
      break if GRID[next_pos] == :wall
      pos, direction = next_pos, next_direction
    end
  end
end

puts (pos.y + 1) * 1000 + (pos.x + 1) * 4 + DIR_VALS[direction]
