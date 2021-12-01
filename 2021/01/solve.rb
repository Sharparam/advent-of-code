#!/usr/bin/env ruby
# frozen_string_literal: true

nums = ARGF.readlines.map(&:to_i)
puts nums.each_cons(2).count { |a, b| a < b }
puts nums.each_cons(3).each_cons(2).count { |a, b| a.sum < b.sum }
