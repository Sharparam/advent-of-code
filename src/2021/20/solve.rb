#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

ALGORITHM = ARGF.readline.strip.chars.map { _1 == '#' ? 1 : 0 }
IMAGE = Hash[ARGF.readlines[1..].flat_map.with_index { |r, y| r.strip.chars.map.with_index { |p, x| [Vector[x, y], p == '#' ? 1 : 0] } }].tap { _1.default = 0 }

SQUARE_DELTAS = [
  Vector[-1, -1], Vector[0, -1], Vector[1, -1],
  Vector[-1,  0], Vector[0,  0], Vector[1,  0],
  Vector[-1,  1], Vector[0,  1], Vector[1,  1]
].freeze

def square_vectors(pos)
  SQUARE_DELTAS.map { pos + _1 }
end

def read(image, pos)
  square_vectors(pos).flat_map { image[_1] }.join.to_i(2)
end

def bounds(image)
  xmin, xmax = image.keys.map { _1[0] }.minmax
  ymin, ymax = image.keys.map { _1[1] }.minmax
  [xmin, xmax, ymin, ymax]
end

def default(step)
  return 0 unless ALGORITHM[0] == 1
  step.even? ? ALGORITHM[0] : ALGORITHM[-1]
end

def enhance(image, step)
  xmin, xmax, ymin, ymax = bounds(image)
  Hash[(xmin - 1..xmax + 1).to_a.product((ymin - 1..ymax + 1).to_a).map { Vector[_1, _2] }.map { [_1, ALGORITHM[read(image, _1)]] }].tap { _1.default = default(step) }
end

def vis(image)
  xmin, xmax, ymin, ymax = bounds(image)
  (ymin..ymax).each do |y|
    (xmin..xmax).each do |x|
      print image[Vector[x, y]] == 0 ? '  ' : '██'
    end
    puts
  end
end

puts 50.times.reduce(IMAGE) { |image, step|
  enhance(image, step).tap { puts _1.values.flatten.sum if step == 1 }
}.values.flatten.sum
