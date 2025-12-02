#!/usr/bin/env ruby
# frozen_string_literal: true

ranges = ARGF.read.scan(/(\d+)-(\d+)/).map { |(a, b)| (a.to_i)..(b.to_i) }

part1 = 0
part2 = 0

ranges.each do |range|
  range.each do |num|
    s = num.to_s
    part1 += num if s.size.even? && s[0...(s.size / 2)] == s[(s.size / 2)..]
    part2 += num if s =~ /^(\d+)\1+$/
  end
end

p part1, part2
