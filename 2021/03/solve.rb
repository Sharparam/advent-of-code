#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.readlines.map(&:strip)

puts input.first.size.times.map { |i| input.map { _1[i] }.tally }.map { |f| f.minmax_by { _2 } }.map { _1.map(&:first) }.transpose.map { _1.join.to_i(2) }.reduce(:*)

oxy = input.dup
input.first.size.times do |i|
  tally = oxy.map { _1[i] }.tally
  m = tally.max_by { |k, v| [v, k] }.first
  oxy.select! { _1[i] == m }
end

co2 = input.dup
input.first.size.times do |i|
  tally = co2.map { _1[i] }.tally
  m = tally.min_by { |k, v| [v, k] }.first
  co2.select! { _1[i] == m }
end

puts oxy.first.to_i(2) * co2.first.to_i(2)
