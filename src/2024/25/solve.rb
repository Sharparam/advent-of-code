#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

P = Vector

GRIDS = ARGF.read.split("\n\n").map do |block|
  grid = Set.new
  block.lines.map(&:chomp).each_with_index do |line, y|
    line.chars.each_with_index do |char, x|
      grid << P[x, y] if char == '#'
    end
  end
  grid
end

puts GRIDS.combination(2).count { |a, b| a.all? { |p| !b.include?(p) } }
