#!/usr/bin/env ruby

ids = ARGF.readlines.map { |l| l.tr('FBLR', '0101').to_i 2 }
min, max = ids.min, ids.max

puts max
puts (min..max).find { |id| !ids.include? id }
