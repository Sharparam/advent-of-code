#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Vector
  def x
    self[0]
  end

  def y
    self[1]
  end
end

P = Vector

CODES = ARGF.readlines(chomp: true).freeze

NUMPAD = [
  [P[0, 0], '7'], [P[1, 0], '8'], [P[2, 0], '9'],
  [P[0, 1], '4'], [P[1, 1], '5'], [P[2, 1], '6'],
  [P[0, 2], '1'], [P[1, 2], '2'], [P[2, 2], '3'],
                  [P[1, 3], '0'], [P[2, 3], 'A'] # rubocop:disable Layout/ArrayAlignment
].to_h.freeze
NUMPAD_EMPTY = P[0, 3].freeze
NUMPAD_MAP = NUMPAD.to_h { [_2, _1] }.freeze

NUMPAD_START = P[2, 3].freeze

DIRPAD = [
                  [P[1, 0], '^'], [P[2, 0], 'A'], # rubocop:disable Layout/FirstArrayElementIndentation
  [P[0, 1], '<'], [P[1, 1], 'v'], [P[2, 1], '>'] # rubocop:disable Layout/ArrayAlignment
].to_h.freeze
DIRPAD_EMPTY = P[0, 0].freeze
DIRPAD_MAP = DIRPAD.to_h { [_2, _1] }.freeze

DIRPAD_START = P[2, 0].freeze

def len(n)
  [0, n].max
end

def find(exclude, map, start, goal)
  pos = start
  paths = [''].to_set

  goal.chars.each do |button|
    new_paths = Set.new
    new_pos = map[button]
    path_x = "#{'<' * len(pos.x - new_pos.x)}#{'>' * len(new_pos.x - pos.x)}#{'^' * len(pos.y - new_pos.y)}#{'v' * len(new_pos.y - pos.y)}A"
    path_y = "#{'^' * len(pos.y - new_pos.y)}#{'v' * len(new_pos.y - pos.y)}#{'<' * len(pos.x - new_pos.x)}#{'>' * len(new_pos.x - pos.x)}A"
    new_paths |= paths.map { _1 + path_x } unless P[new_pos.x, pos.y] == exclude
    new_paths |= paths.map { _1 + path_y } unless P[pos.x, new_pos.y] == exclude
    paths = new_paths
    pos = new_pos
  end

  paths
end

$cache = {}
def chunk_min(str, n)
  return str.size if n == 0
  return 1 if str == 'A'
  key = [str, n]
  return $cache[key] if $cache.key? key
  paths = find(DIRPAD_EMPTY, DIRPAD_MAP, DIRPAD_START, str)
  min_size = paths.map(&:size).min
  min_paths = paths.select { _1.size == min_size }
  $cache[key] = min_paths.map do |path|
    path.split('A').sum do |a|
      chunk_min("#{a}A", n - 1)
    end
  end.min
end

def solve(code, n)
  find(NUMPAD_EMPTY, NUMPAD_MAP, NUMPAD_START, code).map do |path|
    path.split('A').sum { chunk_min("#{_1}A", n) }
  end.min * code[..-2].to_i
end

puts CODES.sum { solve(_1, 2) }
puts CODES.sum { solve(_1, 25) }
