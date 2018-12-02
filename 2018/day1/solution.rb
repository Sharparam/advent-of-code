#!/usr/bin/env ruby

freqs = File.readlines('input.txt').map(&:to_i)

puts "Part 1: #{freqs.sum}"

multiples = Set.new
freq = 0

freqs.cycle do |current|
    freq += current
    break if multiples.include? freq
    multiples.add freq
end

puts "Part 2: #{freq}"
