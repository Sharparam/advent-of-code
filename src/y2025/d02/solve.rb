#!/usr/bin/env ruby
# frozen_string_literal: true

ranges = ARGF.read.scan(/(\d+)-(\d+)/).map { |(a, b)| (a.to_i)..(b.to_i) }

puts ranges.flat_map { |range|
  range.select { |n| n.size.even? && n.to_s.then { |s| s[0...(s.size / 2)] == s[(s.size / 2)..] } }
}.sum
