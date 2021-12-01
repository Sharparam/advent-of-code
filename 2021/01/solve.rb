#!/usr/bin/env ruby
# frozen_string_literal: true

nums = ARGF.readlines.map(&:to_i)

current = nums.max + 1
count = 0

nums.each do |num|
  count += 1 if num > current
  current = num
end

puts count

current = nums.max + 1
count = 0

nums.each_cons(3) do |g|
  count += 1 if g.sum > current
  current = g.sum
end

puts count
