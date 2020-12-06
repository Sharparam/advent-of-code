#!/usr/bin/env ruby

groups = ARGF.read.split("\n\n").map { |g|
  g.lines.map { |l| l.strip.chars.map(&:to_sym) }
}

puts groups.sum { |g| g.flatten.uniq.size }
puts groups.sum { |g| g.reduce(:&).size }
