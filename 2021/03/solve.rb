#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.readlines
freqs = Hash.new(0)
cols = [''] * input.first.size

input.each do |line|
  line.chars.each_with_index do |c, i|
    cols[i] += c
  end
end

gamma = ''
epsilon = ''

cols.each do |col|
  t = col.chars.tally
  gamma += t.max_by { |_, v| v }.first
  epsilon += t.min_by { |_, v| v }.first
end

puts gamma.to_i(2) * epsilon.to_i(2)

oxy_nums = input.dup
index = 0
while oxy_nums.size > 1
  consider = oxy_nums.map { |n| n[index] }
  t = consider.tally
  m = t.max_by { |k, v| v + (k == '1' ? 0.5 : 0) }.first
  oxy_nums.reject! { |n| n[index] != m }
  index += 1
end

oxy = oxy_nums.first.to_i(2)

co2_nums = input.dup
index = 0
while co2_nums.size > 1
  consider = co2_nums.map { |n| n[index] }
  t = consider.tally
  m = t.min_by { |k, v| v + (k == '1' ? 0.5 : 0) }.first
  co2_nums.reject! { |n| n[index] != m }
  index += 1
end

co2 = co2_nums.first.to_i(2)

puts oxy * co2
