#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'engine'

input = $stdin.readlines.map { |l| l.split.map(&:to_i) }

puts count_triangles input
