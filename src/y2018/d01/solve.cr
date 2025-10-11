#!/usr/bin/env crystal

freqs = File.read_lines("input.txt").map(&.to_i)

puts "Part 1: #{freqs.sum}"

multiples = Set(Int32).new
freq = 0

freqs.cycle do |current|
  freq += current
  break unless multiples.add? freq
end

puts "Part 2: #{freq}"
