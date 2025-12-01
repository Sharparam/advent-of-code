#!/usr/bin/env ruby
# frozen_string_literal: true

nums = ARGF.map { |l| (l[0] == ?L ? -1 : 1) * l[1..].to_i }

dial = 50

part1 = 0
part2 = 0

nums.each do |n|
  d, m = n.abs.divmod 100
  s = n / n.abs
  a = m * s
  part2 += d
  part2 += 1 if m != 0 && dial != 0 && (dial + a <= 0 || dial + a >= 100)
  dial = (dial + n) % 100
  part1 += 1 if dial == 0
end

puts part1
puts part2
