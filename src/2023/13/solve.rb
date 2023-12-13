#!/usr/bin/env ruby
# frozen_string_literal: true

patterns = ARGF.read.split("\n\n").map do |text|
  lines = text.lines(chomp: true).map { |l| l.chars.map { _1 == ?# } }
  [lines, lines.transpose]
end

def perfect?(arr, i)
  return false if i == arr.size - 1

  i.downto(0).each do |j|
    o = 2 * i - j + 1
    break if o == arr.size
    match = arr[j] == arr[o]
    return false unless match
  end

  true
end

def gen_variations(arr)
  height, width = arr.size, arr[0].size

  variations = []

  (0...width).each do |x|
    (0...height).each do |y|
      dupe = arr.map(&:clone)
      dupe[y][x] = !dupe[y][x]
      variations << dupe
    end
  end

  variations
end

sum = patterns.reduce([0, 0]) do |a, pair|
  first_cands = (0...pair[0].size).to_a
  second_cands = (0...pair[1].size).to_a
  first = first_cands.find { perfect?(pair[0], _1) }
  second = second_cands.find { perfect?(pair[1], _1) }

  alt_first_cands = first.nil? ? first_cands : first_cands - [first]
  alt_second_cands = second.nil? ? second_cands : second_cands - [second]

  first_vars = gen_variations(pair[0])
  second_vars = gen_variations(pair[1])

  alt_first = alt_first_cands.find { |c| first_vars.any? { perfect?(_1, c) } }
  alt_second = alt_second_cands.find { |c| second_vars.any? { perfect?(_1, c) } }

  s = 0

  s += (first + 1) * 100 unless first.nil?
  s += second + 1 unless second.nil?

  alt_s = 0

  alt_s += (alt_first + 1) * 100 unless alt_first.nil?
  alt_s += alt_second + 1 unless alt_second.nil?

  [a[0] + s, a[1] + alt_s]
end

puts sum
