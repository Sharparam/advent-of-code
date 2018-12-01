#!/usr/bin/env ruby

freqs = File.readlines('input.txt').map(&:to_i)

puts "Part 1: #{freqs.inject(0) { |a, e| a + e }}"

occurrences = Hash.new(0).tap { |h| h[0] = 1 }
found = nil
freq = 0
ind = 0

while !found do
    freq += freqs[ind]
    occurrences[freq] += 1

    if occurrences[freq] > 1
        found = freq
    end

    ind += 1
    ind = 0 if ind >= freqs.size
end

puts "Part 2: #{found}"
