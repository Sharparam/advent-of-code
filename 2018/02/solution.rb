#!/usr/bin/env ruby

ids = File.readlines('input.txt')

twos = 0
threes = 0

ids.each do |id|
    counts = id.chars.reduce(Hash.new(0)) { |h, e| h[e] += 1; h }
    twos += 1 if counts.any? { |k, v| v == 2 }
    threes += 1 if counts.any? { |k, v| v == 3 }
end

puts "Part 1: #{twos * threes}"

def check(a, b)
    diff_indices = a.each_char.with_index.select { |c, i| c != b[i] }.map(&:last)
    $diff_i = diff_indices.first if diff_indices.size == 1
end

puts "Part 2: #{ids.combination(2).find { |c| check *c }.first.tap { |s| s.slice! $diff_i }}"
