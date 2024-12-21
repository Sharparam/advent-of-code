#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

P = Vector

# CODES = ARGF.readlines(chomp: true)
CODES = ARGF.readlines.map(&:chomp).freeze

NUMPAD = [
  [P[0, 0], '7'], [P[1, 0], '8'], [P[2, 0], '9'],
  [P[0, 1], '4'], [P[1, 1], '5'], [P[2, 1], '6'],
  [P[0, 2], '1'], [P[1, 2], '2'], [P[2, 2], '3'],
                  [P[1, 3], '0'], [P[2, 3], 'A'] # rubocop:disable Layout/ArrayAlignment
].to_h.freeze
NUMPAD_MAP = NUMPAD.to_h { [_2, _1] }.freeze

NUMPAD_START = P[2, 3].freeze

DIRPAD = [
                  [P[1, 0], '^'], [P[2, 0], 'A'], # rubocop:disable Layout/FirstArrayElementIndentation
  [P[0, 1], '<'], [P[1, 1], 'v'], [P[2, 1], '>'] # rubocop:disable Layout/ArrayAlignment
].to_h.freeze
DIRPAD_MAP = DIRPAD.to_h { [_2, _1] }.freeze

DIRPAD_START = P[2, 0].freeze

NORTH = P[0, -1].freeze
WEST = P[-1, 0].freeze
EAST = P[1, 0].freeze
SOUTH = P[0, 1].freeze

DIRS = [NORTH, WEST, EAST, SOUTH].freeze
DIRMAP = {
  '^' => NORTH,
  '<' => WEST,
  'v' => SOUTH,
  '>' => EAST
}.freeze

REVERSE_DIRMAP = DIRMAP.to_h { [_2, _1] }.freeze

def neighbors(grid, pos)
  DIRS.map { |d| pos + d }.reject { |p| grid[p].nil? }
end

def manhattan(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

def shortest(grid, grid_map, start, goal)
  goal = goal.dup

  pos = start
  # cost = 0
  path = []

  until goal.empty?
    next_btn = goal.shift
    next_pos = grid_map[next_btn]

    if grid[pos] != next_btn
      h_diff = next_pos[0] - pos[0]
      v_diff = next_pos[1] - pos[1]
      h_char = h_diff < 0 ? '<' : '>'
      v_char = v_diff < 0 ? '^' : 'v'
      h_dist = (next_pos[0] - pos[0]).abs
      v_dist = (next_pos[1] - pos[1]).abs
      dist = h_dist + v_dist
      # cost += dist
      # if v_diff != 0 && h_diff > 0 && !grid[pos + Vector[0, v_diff]].nil?
      #   v_dist.times { path.push v_char }
      #   h_dist.times { path.push h_char }
      # else
      #   h_dist.times { path.push h_char }
      #   v_dist.times { path.push v_char }
      # end
      if h_diff != 0 && v_diff < 0 && !grid[pos + Vector[h_diff, 0]].nil?
        h_dist.times { path.push h_char }
        v_dist.times { path.push v_char }
      else
        v_dist.times { path.push v_char }
        h_dist.times { path.push h_char }
      end
    end

    # cost += 1
    path.push 'A'
    # puts "current: #{pos}, next: #{next_pos}, dist: #{dist}"
    pos = next_pos
  end

  # [cost, path]
  path
end

def shortest_v2(grid, grid_map, start, goal)
  goal = goal.dup

  pos = start
  paths = [[]]

  until goal.empty?
    next_btn = goal.shift
    next_pos = grid_map[next_btn]

    if grid[pos] != next_btn
      h_diff = next_pos[0] - pos[0]
      v_diff = next_pos[1] - pos[1]
      h_char = h_diff < 0 ? '<' : '>'
      v_char = v_diff < 0 ? '^' : 'v'
      h_dist = (next_pos[0] - pos[0]).abs
      v_dist = (next_pos[1] - pos[1]).abs
      if grid[pos + Vector[h_diff, 0]] && grid[pos + Vector[0, v_diff]]
        # both variants possible, split
        var_paths = paths.map(&:dup)
        var_paths.each do |path|
          v_dist.times { path.push v_char }
          h_dist.times { path.push h_char }
        end
        paths.each do |path|
          h_dist.times { path.push h_char }
          v_dist.times { path.push v_char }
        end
        paths.concat var_paths
      elsif grid[pos + Vector[h_diff, 0]].nil?
        paths.each do |path|
          v_dist.times { path.push v_char }
          h_dist.times { path.push h_char }
        end
      else
        paths.each do |path|
          h_dist.times { path.push h_char }
          v_dist.times { path.push v_char }
        end
      end

      paths.uniq!
    end

    paths.each do |path|
      path.push 'A'
    end
    # puts "current: #{pos}, next: #{next_pos}, dist: #{dist}"
    pos = next_pos
  end

  # size = paths.map(&:size).min
  paths # .select { _1.size == size }
end

def solve(goal, count)
  # num_cost, num_path = shortest(NUMPAD, NUMPAD_MAP, NUMPAD_START, goal.chars)
  # puts "#{goal}: #{num_path.join} (#{num_cost})"
  # first_cost, first_path = shortest(DIRPAD, DIRPAD_MAP, DIRPAD_START, num_path)
  # puts "  #{first_path.join} (#{first_cost})"
  # second_cost, second_path = shortest(DIRPAD, DIRPAD_MAP, DIRPAD_START, first_path)
  # puts "  #{second_path.join} (#{second_cost})"

  # second_cost * goal[..-2].to_i

  path = shortest(NUMPAD, NUMPAD_MAP, NUMPAD_START, goal.chars)

  count.times do |i|
    puts "solving #{i + 1}"
    path = shortest(DIRPAD, DIRPAD_MAP, DIRPAD_START, path)
  end

  path.size * goal[..-2].to_i
end

def solve_v2(goal)
  # num_paths = shortest_v2(NUMPAD, NUMPAD_MAP, NUMPAD_START, goal.chars)
  # first_paths = num_paths.map do |path|
  #   shortest_v2(DIRPAD, DIRPAD_MAP, DIRPAD_START, path)
  # end.flatten(1)

  # second_paths = first_paths.map do |path|
  #   shortest_v2(DIRPAD, DIRPAD_MAP, DIRPAD_START, path)
  # end.flatten(1)

  # # p second_paths.map(&:size).uniq

  # second_paths.min_by(&:size).size * goal[..-2].to_i

  paths = shortest_v2(NUMPAD, NUMPAD_MAP, NUMPAD_START, goal.chars)

  25.times do |i|
    puts "solving #{i + 1}"
    paths = paths.map do |path|
      shortest_v2(DIRPAD, DIRPAD_MAP, DIRPAD_START, path)
    end.flatten(1)
    min_size = paths.map(&:size).min
    paths = paths.select { _1.size == min_size }.uniq
  end

  paths[0].size * goal[..-2].to_i
end

# p shortest(NUMPAD_MAP, NUMPAD_START, '029A'.chars)

# p solve('029A')

puts CODES.sum { solve(_1, 25) }
# puts CODES.sum { solve_v2 _1 }

# binding.irb
