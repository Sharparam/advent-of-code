#!/usr/bin/env ruby

groups = ARGF.read.split("\n\n").map { |g|
  g.split.map { |l| l.chars }
}

puts groups.sum { |g| g.flatten.uniq.size }
puts groups.sum { |g| g.reduce(:&).size }
