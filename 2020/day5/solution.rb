#!/usr/bin/env ruby

codes = ARGF.readlines.map { |l| l.chomp.chars.map(&:to_sym) }

def decode(code)
  row = (0..127).bsearch { %i[F L R].include? code.shift }
  col = (0..7).bsearch { [:L, nil].include? code.shift }
  row * 8 + col
end

ids = codes.map { |c| decode c }
min, max = ids.min, ids.max

puts max
puts (min..max).find { |id| !ids.include? id }
