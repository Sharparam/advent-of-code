#!/usr/bin/env ruby
# frozen_string_literal: true

freqs = File.readlines('input.txt').map(&:to_i)

puts "Part 1: #{freqs.sum}"

multiples = Set.new
freq = 0

freqs.cycle do |current|
  freq += current
  break unless multiples.add? freq
end

puts "Part 2: #{freq}"
