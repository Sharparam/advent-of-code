#!/usr/bin/env crystal

nums = ARGF.each_line.map(&.to_i).to_a
puts nums.each.cons_pair.count { |a, b| a < b }
puts nums.each_cons(3).cons_pair.count { |a, b| a.sum < b.sum }
