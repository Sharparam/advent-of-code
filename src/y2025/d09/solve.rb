#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

reds = ARGF.map { Vector[*_1.split(',').map(&:to_i)] }

puts reds.combination(2).map { |a, b|
  ((a[0] - b[0]).abs + 1) * ((a[1] - b[1]).abs + 1)
}.max
