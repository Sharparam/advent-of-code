#!/usr/bin/env ruby
# frozen_string_literal: true

require 'digest'
require 'matrix'

# #########
# #S| | | #
# #-#-#-#-#
# # | | | #
# #-#-#-#-#
# # | | | #
# #-#-#-#-#
# # | | |
# ####### V

WIDTH = 4
HEIGHT = 4
START = Vector[0, 0]
GOAL = Vector[3, 3]
PASSCODE = (ARGV[0] || 'pgflpeqp').freeze
DIRECTIONS = [
  [Vector[0, -1], :U],
  [Vector[0, 1], :D],
  [Vector[-1, 0], :L],
  [Vector[1, 0], :R]
].freeze
OPEN = %w[b c d e f].to_set.freeze

def wall?(pos)
  x, y = *pos
  x < 0 || x >= WIDTH || y < 0 || y >= HEIGHT
end

def valid_positions(pos, moves)
  moves = moves.map(&:to_s).join
  data = PASSCODE + moves
  md5 = Digest::MD5.hexdigest data
  first = md5[..3]
  valid_dirs = DIRECTIONS.select.with_index { |_, i| OPEN.include? first[i] }
  valid_dirs.map { |p, d| [pos + p, d] }.reject { |p, _| wall? p }
end

def shortest(pos, path)
  return path if pos == GOAL
  move_to = valid_positions(pos, path)
  return nil if move_to.empty? # dead end
  move_to.map do |p, d|
    shortest(p, path + [d])
  end.compact.min_by(&:size)
end

def longest(pos, path)
  return path if pos == GOAL
  move_to = valid_positions(pos, path)
  return nil if move_to.empty? # dead end
  move_to.map do |p, d|
    longest(p, path + [d])
  end.compact.max_by(&:size)
end

puts shortest(START, []).join
puts longest(START, []).size
