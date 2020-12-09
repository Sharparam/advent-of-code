#!/usr/bin/env ruby
# frozen_string_literal: true

SIZE = 25.freeze
NUMS = ARGF.readlines.map(&:to_i).freeze

part1 = NUMS[SIZE..].find.with_index { |n, i|
  ri = i + SIZE
  !NUMS[ri - SIZE...ri].combination(2).any? { _1 + _2 == n }
}.tap { puts _1 }

puts (2..).lazy.map { |size|
  NUMS.each_cons(size).find { _1.sum == part1 }
}.find { _1 }.then { _1.min + _1.max }
