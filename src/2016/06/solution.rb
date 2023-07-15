#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

counts = []

STDIN.readlines.map(&:strip).tap do |input|
  input.first.size.times { counts << Hash.new(0) }
end.each do |message|
  message.chars.each.with_index { |c, i| counts[i][c] += 1 }
end

sorted = counts.map { |p| p.keys.sort { |a, b| p[b] <=> p[a] } }

puts "(1) #{sorted.map { |c| c.first }.join}"
puts "(2) #{sorted.map { |c| c.last  }.join}"
