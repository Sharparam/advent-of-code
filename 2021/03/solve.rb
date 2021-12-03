#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.readlines.map(&:strip)

puts input.first.size.times.map { |i| input.map { _1[i] }.tally }.map { |f| f.minmax_by { _2 } }.map { _1.map(&:first) }.transpose.map { _1.join.to_i(2) }.reduce(:*)

oxy_nums = input.dup
index = 0
while oxy_nums.size > 1
  consider = oxy_nums.map { |n| n[index] }
  t = consider.tally
  m = t.max_by { |k, v| [v, k] }.first
  oxy_nums.reject! { |n| n[index] != m }
  index += 1
end

oxy = oxy_nums.first.to_i(2)

co2_nums = input.dup
index = 0
while co2_nums.size > 1
  consider = co2_nums.map { |n| n[index] }
  t = consider.tally
  m = t.min_by { |k, v| [v, k] }.first
  co2_nums.reject! { |n| n[index] != m }
  index += 1
end

co2 = co2_nums.first.to_i(2)

puts oxy * co2
