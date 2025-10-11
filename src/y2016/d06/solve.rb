#!/usr/bin/env ruby
# frozen_string_literal: true

counts = []

$stdin.readlines.map(&:strip).tap do |input|
  input.first.size.times { counts << Hash.new(0) }
end.each do |message|
  message.chars.each.with_index { |c, i| counts[i][c] += 1 }
end

sorted = counts.map { |p| p.keys.sort { |a, b| p[b] <=> p[a] } }

puts "(1) #{sorted.map(&:first).join}"
puts "(2) #{sorted.map(&:last).join}"
