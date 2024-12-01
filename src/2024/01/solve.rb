#!/usr/bin/env ruby
# frozen_string_literal: true

left, right = ARGF.readlines.map(&:split).map { _1.map(&:to_i) }.transpose
puts left.sort.zip(right.sort).map { (_1 - _2).abs }.sum
puts right.tally.then { |c| left.sum { _1 * (c[_1] || 0) } }
