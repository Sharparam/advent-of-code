#!/usr/bin/env ruby
# frozen_string_literal: true

orderings, updates = ARGF.read.split "\n\n"

orderings = orderings.lines.map { _1.split("|").map(&:to_i) }
rules = orderings.reduce(Hash.new { _1[_2] = Set.new }) { |a, (l, r)| a[l].add(r); a }
updates = updates.lines.map { _1.split(",").map(&:to_i) }

incorrect = []

puts updates.sum { |pages|
  next pages[pages.size / 2] if pages.size.times.all? { |i|
    pages[..i].then { |*h, t| h.all? { !rules[t].include? _1 } }
  }
  incorrect << pages
  0
}

puts incorrect.map { _1.sort { |a, b|
  rules[a].include?(b) ? -1 : rules[b].include?(a) ? 1 : 0
} }.sum { _1[_1.size / 2] }
