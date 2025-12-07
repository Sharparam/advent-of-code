#!/usr/bin/env ruby
# frozen_string_literal: true

splits = 0
counters = Hash.new 0

ARGF.each_line(chomp: true) do |line|
  line.chars.each_with_index do |char, col|
    if char == ?^
      splits += 1 if counters[col] > 0
      counters[col - 1] += counters[col]
      counters[col + 1] += counters[col]
      counters[col] = 0
    elsif char == ?S
      counters[col] = 1
    end
  end
end

puts splits
puts counters.values.sum
