#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'aoc/point'

sections = ARGF.read.split("\n\n")

presents = sections[...-1].map { |p|
  shape = []
  p.lines[1..].each_with_index { |l, row|
    l.strip.chars.each_with_index { |c, col|
      shape.push AoC::Point2[col, row] if c == ?#
    }
  }
  shape
}

class Tree
  attr_reader :width, :height, :requirements

  def initialize(width, height, requirements)
    @width = width
    @height = height
    @requirements = requirements
  end

  def to_s
    "#{width}x#{height} [#{requirements.join(', ')}]"
  end
end

trees = sections[-1].scan(/(\d+)x(\d+):(( \d+)+)/).map { |w, h, r|
  Tree.new w.to_i, h.to_i, r.split.map(&:to_i)
}

presents.each { |p| puts p.map(&:to_s).join(' ') }

puts trees.count { |t| t.width * t.height >= t.requirements.sum { |r| r * 9 } }
