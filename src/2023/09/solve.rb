#!/usr/bin/env ruby
# frozen_string_literal: true

def extrapolate(seq)
  return [0, 0] if seq.all? 0
  extrapolate(seq.each_cons(2).map { _2 - _1 }).then { [seq[-1] + _1, seq[0] - _2] }
end

puts ARGF.readlines(chomp: true).map { _1.split.map(&:to_i) }.map(&method(:extrapolate)).transpose.map(&:sum)

