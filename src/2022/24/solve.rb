#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

grid = {}
blizzards = []

ARGF.readlines.map(&:strip).each_with_index do |line, y|
  line.chars.each_with_index do |c, x|
    case c
    when '#'
      grid[Vector[x, y]] = :wall
    when '.'
      grid[Vector[x, y]] = :open
    when '>'
      grid[Vector[x, y]] = :open
      blizzards.push [Vector[x, y], Vector[1, 0]]
    when 'v'
      grid[Vector[x, y]] = :open
      blizzards.push [Vector[x, y], Vector[0, 1]]
    when '<'
      grid[Vector[x, y]] = :open
      blizzards.push [Vector[x, y], Vector[-1, 0]]
    when '^'
      grid[Vector[x, y]] = :open
      blizzards.push [Vector[x, y], Vector[0, -1]]
    end
  end
end

MIN_X, MAX_X = grid.keys.map { _1[0] }.minmax
MIN_Y, MAX_Y = grid.keys.map { _1[1] }.minmax

START_X = (MIN_X..MAX_X).find { grid[Vector[_1, MIN_Y]] == :open }
START = Vector[START_X, MIN_Y]
GOAL_X = (MIN_X..MAX_X).find { grid[Vector[_1, MAX_Y]] == :open }
GOAL = Vector[GOAL_X, MAX_Y]

DIRECTIONS = [
  Vector[1, 0],
  Vector[0, 1],
  Vector[-1, 0],
  Vector[0, -1],
  Vector[0, 0]
].freeze

def advance_blizzards(blizzards)
  blizzards.map do |pos, dir|
    new_pos = pos + dir
    x, y = new_pos[0], new_pos[1]
    if x <= MIN_X
      [Vector[MAX_X - 1, y], dir]
    elsif x >= MAX_X
      [Vector[MIN_X + 1, y], dir]
    elsif y <= MIN_Y
      [Vector[x, MAX_Y - 1], dir]
    elsif y >= MAX_Y
      [Vector[x, MIN_Y + 1], dir]
    else
      [new_pos, dir]
    end
  end
end

blizzard_states = [blizzards]
blizzard_hashes = [blizzards.hash].to_set

loop do
  new_blizzards = advance_blizzards(blizzard_states[-1])
  new_hash = new_blizzards.hash
  if blizzard_hashes.include? new_hash
    STDERR.puts "BLIZZARD CYCLE FOUND at #{blizzards.size} blizzards"
    break
  end
  blizzard_states.push new_blizzards
  blizzard_hashes.add new_hash
end

BLIZZARD_STATES = blizzard_states.map { |b| b.map { [_1[0], true] }.to_h }

def valid_pos(grid, blizzard_state, pos, start, goal)
  possible = []

  DIRECTIONS.each do |dir|
    new_pos = pos + dir
    possible.push new_pos if new_pos == goal || new_pos == start
    next if blizzard_state[new_pos]
    next if new_pos[0] <= MIN_X
    next if new_pos[0] >= MAX_X
    next if new_pos[1] <= MIN_Y
    next if new_pos[1] >= MAX_Y
    possible.push new_pos
  end

  possible
end

def solve(grid, start, goal, b_i = 0)
  queue = [
    [start, 0, b_i]
  ]
  seen = {}
  last_report_steps = 0
  while queue.any?
    pos, steps, blizzard_i = queue.shift

    if steps % 100 == 0 && last_report_steps != steps
      STDERR.puts "Steps: #{steps}"
      last_report_steps = steps
    end

    if pos == goal
      STDERR.puts "Found solution at #{steps} steps"
      return [steps, blizzard_i]
    end

    new_blizzard_i = (blizzard_i + 1) % BLIZZARD_STATES.size
    new_blizzards = BLIZZARD_STATES[new_blizzard_i]
    next if !seen.dig(new_blizzard_i, pos).nil? && seen[new_blizzard_i][pos] <= steps

    seen[new_blizzard_i] ||= {}
    seen[new_blizzard_i][pos] ||= steps

    possible = valid_pos(grid, new_blizzards, pos, start, goal)
    possible.each do |new_pos|
      queue.push [new_pos, steps + 1, new_blizzard_i]
    end
  end

  abort '=== FAILED TO FIND PATH ==='
end

part1, part1_bi = solve(grid, START, GOAL)

puts part1
STDERR.puts "Part 1 BI: #{part1_bi}"

STDERR.puts 'Go back for snacks:'
snacks, snacks_bi = solve(grid, GOAL, START, part1_bi)
STDERR.puts "Got snacks at #{snacks} steps"
STDERR.puts 'Go back again:'
part2, part2_bi = solve(grid, START, GOAL, snacks_bi)
STDERR.puts "Got back in #{part2} steps"
puts part1 + snacks + part2
