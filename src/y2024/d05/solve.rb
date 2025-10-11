#!/usr/bin/env ruby
# frozen_string_literal: true

orderings, updates = ARGF.read.split "\n\n"

orderings = orderings.lines.map { _1.split('|').map(&:to_i) }
rules = orderings.each_with_object(Hash.new { _1[_2] = Set.new }) { |(l, r), a| a[l].add(r) }
updates = updates.lines.map { _1.split(',').map(&:to_i) }

incorrect = []

puts updates.sum { |pages|
  next pages[pages.size / 2] if pages.size.times.all? { |i| pages[..i].then { |*h, t| h.all? { !rules[t].include? _1 } } }
  incorrect << pages
  0
}

puts incorrect.sum { _1.sort { |a, b| rules[a].include?(b) ? -1 : rules[b].include?(a) ? 1 : 0 }[_1.size / 2] }
