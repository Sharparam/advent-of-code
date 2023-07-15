#!/usr/bin/env ruby
# frozen_string_literal: true

pairs = ARGF.readlines.map { |l| l.chomp.split(',').map { |s| Range.new(*s.split('-').map(&:to_i)) } }

puts pairs.count { |p| p.permutation(2).any? { _1.cover? _2 } }
puts pairs.count { |p| p[0].cover?(p[1].min) || p[1].cover?(p[0].min) }
