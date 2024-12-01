#!/usr/bin/env ruby
# frozen_string_literal: true

left, right = ARGF.map { _1.split.map(&:to_i) }.transpose
puts left.sort.zip(right.sort).sum { (_1 - _2).abs }
puts right.tally.then { |c| left.sum { _1 * (c[_1] || 0) } }
