#!/usr/bin/env ruby
# frozen_string_literal: true

orderings, updates = ARGF.read.split "\n\n"

orderings = orderings.lines.map { _1.split("|").map(&:to_i) }
RULES = orderings.reduce({}) { |a, (left, right)| (a[left] ||= Set.new).add(right); a }
updates = updates.lines.map { _1.split(",").map(&:to_i) }

incorrect = []

puts updates.sum { |pages|
  next pages[pages.size / 2] if pages.size.times.all? { |i|
    *before, current = pages[..i]
    !RULES.key?(current) || before.all? { !RULES[current].include? _1 }
  }
  incorrect << pages
  0
}

def sort(a, b)
  if RULES.key?(a) && RULES[a].include?(b)
    -1
  elsif RULES.key?(b) && RULES[b].include?(a)
    1
  else
    0
  end
end

puts incorrect.map { _1.sort(&method(:sort)) }.sum { _1[_1.size / 2] }
